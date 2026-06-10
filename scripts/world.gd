extends Node3D
## UNDYING — the game manager. Builds the world, runs the day/night cycle,
## sends the hordes, keeps score, and decides when you've won or died.
##
## The loop (the one the ads promise and never deliver):
##   DAY    — gather wood and stone, build walls and traps, breathe.
##   NIGHT  — the dead come for you. Your base is all that stands between.
##   DAWN   — survive it, heal, build bigger. Five nights and you win.

enum Phase { DAY, NIGHT }

const DAY_LENGTH := 110.0
const NIGHT_LENGTH := 80.0
const NIGHTS_TO_WIN := 5
const WORLD_SIZE := 80.0
const SPAWN_RADIUS := 36.0

const ZombieScript := preload("res://scripts/zombie.gd")
const ResourceNodeScript := preload("res://scripts/resource_node.gd")
const PlayerScene := preload("res://player.tscn")

var phase: int = Phase.DAY
var phase_time_left: float = DAY_LENGTH
var night_number: int = 0
var kills: int = 0
var resources := {"wood": 0, "stone": 0}
var game_ended := false

var spawn_queue: Array[String] = []
var spawn_interval := 2.0
var spawn_timer := 0.0

var sun: DirectionalLight3D
var env: Environment
var player: CharacterBody3D

# --- HUD ---
var ui: CanvasLayer
var health_fill: ColorRect
var hp_label: Label
var wood_label: Label
var stone_label: Label
var kills_label: Label
var time_label: Label
var build_label: Label
var announce_label: Label
var start_prompt: Label
var damage_flash: ColorRect
var announce_tween: Tween


func _ready() -> void:
	_setup_environment()
	_setup_ground()
	_setup_boundaries()
	_scatter_resources()
	_setup_hud()
	_spawn_player()
	announce("DAY 1 — Gather wood and stone. Build walls. Night is coming.")


func _process(delta: float) -> void:
	if game_ended:
		return
	phase_time_left -= delta
	_update_lighting(delta)
	_update_time_label()

	if phase == Phase.NIGHT:
		_process_spawning(delta)
		# dawn arrives when the clock runs out AND the horde is dead or burned away
		if phase_time_left <= 0.0:
			_begin_day()
	elif phase_time_left <= 0.0:
		_begin_night()


# ---------------------------------------------------------------- phases

func _begin_night() -> void:
	phase = Phase.NIGHT
	phase_time_left = NIGHT_LENGTH
	night_number += 1

	# compose tonight's horde — bigger and nastier every night
	var total := 4 + (night_number - 1) * 3
	var runners := int(total * 0.3) if night_number >= 2 else 0
	var brutes := night_number - 2 if night_number >= 3 else 0
	var walkers := total - runners - brutes

	spawn_queue.clear()
	for i in walkers:
		spawn_queue.append("walker")
	for i in runners:
		spawn_queue.append("runner")
	for i in brutes:
		spawn_queue.append("brute")
	spawn_queue.shuffle()

	# spread the spawns across the first half of the night
	spawn_interval = (NIGHT_LENGTH * 0.5) / float(total)
	spawn_timer = 1.5

	if night_number == NIGHTS_TO_WIN:
		announce("NIGHT %d — THE LAST NIGHT. Everything they have. Hold the line." % night_number)
	else:
		announce("NIGHT %d — They're coming. %d of them." % [night_number, total])


func _begin_day() -> void:
	phase = Phase.DAY
	phase_time_left = DAY_LENGTH
	spawn_queue.clear()

	# the dawn burns away whatever's left of the horde
	for zombie in get_tree().get_nodes_in_group("zombie"):
		zombie.take_damage(99999.0)

	if night_number >= NIGHTS_TO_WIN:
		victory()
	else:
		announce("DAWN — You survived night %d of %d. Heal up. Build higher." % [night_number, NIGHTS_TO_WIN])


func _process_spawning(delta: float) -> void:
	if spawn_queue.is_empty():
		return
	spawn_timer -= delta
	if spawn_timer > 0.0:
		return
	spawn_timer = spawn_interval

	var breed: String = spawn_queue.pop_back()
	var zombie := ZombieScript.new()
	zombie.setup(breed)
	zombie.world = self
	var angle := randf() * TAU
	zombie.position = Vector3(cos(angle) * SPAWN_RADIUS, 0.5, sin(angle) * SPAWN_RADIUS)
	add_child(zombie)


# ---------------------------------------------------------------- scoring & state

func add_resource(kind: String, amount: int) -> void:
	resources[kind] += amount
	_update_resource_labels()


func can_afford(cost: Dictionary) -> bool:
	for kind in cost:
		if resources[kind] < cost[kind]:
			return false
	return true


func try_spend(cost: Dictionary) -> bool:
	if not can_afford(cost):
		return false
	for kind in cost:
		resources[kind] -= cost[kind]
	_update_resource_labels()
	return true


func on_zombie_killed() -> void:
	kills += 1
	kills_label.text = "Kills: %d" % kills


func on_player_damaged() -> void:
	# red screen flash so getting hit is unmistakable
	damage_flash.modulate.a = 0.45
	create_tween().tween_property(damage_flash, "modulate:a", 0.0, 0.4)
	_update_health_bar()


func game_over() -> void:
	if game_ended:
		return
	game_ended = true
	_show_end_screen("YOU DIED", "The horde got you on night %d.\nKills: %d   Walls don't build themselves — try again." % [maxi(night_number, 1), kills], Color(0.8, 0.1, 0.1))


func victory() -> void:
	if game_ended:
		return
	game_ended = true
	_show_end_screen("YOU SURVIVED", "Five nights. %d of the dead put down.\nThis is what the ads promised. You actually did it." % kills, Color(0.2, 0.8, 0.3))


# ---------------------------------------------------------------- world building

func _setup_environment() -> void:
	sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	sun.light_energy = 1.2
	sun.shadow_enabled = true
	add_child(sun)

	env = Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_horizon_color = Color(0.55, 0.5, 0.45)
	sky_mat.ground_horizon_color = Color(0.4, 0.38, 0.34)
	sky.sky_material = sky_mat
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.4

	# atmospheric fog — thin and warm by day, thick and cold by night
	env.fog_enabled = true
	env.fog_density = 0.01
	env.fog_light_color = Color(0.7, 0.72, 0.7)

	# a bit of grit: gentle tonemapping so highlights don't blow out
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC

	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)


func _update_lighting(delta: float) -> void:
	# ease the world between warm daylight and cold, foggy moonlight
	var is_day := phase == Phase.DAY
	var target_energy := 1.2 if is_day else 0.06
	var target_ambient := 0.4 if is_day else 0.08
	var target_color := Color(1.0, 0.95, 0.85) if is_day else Color(0.45, 0.55, 0.95)
	var target_fog := 0.012 if is_day else 0.05
	var target_fog_color := Color(0.7, 0.72, 0.7) if is_day else Color(0.12, 0.14, 0.22)
	var weight := clampf(delta * 1.0, 0.0, 1.0)
	sun.light_energy = lerpf(sun.light_energy, target_energy, weight)
	env.ambient_light_energy = lerpf(env.ambient_light_energy, target_ambient, weight)
	sun.light_color = sun.light_color.lerp(target_color, weight)
	env.fog_density = lerpf(env.fog_density, target_fog, weight)
	env.fog_light_color = env.fog_light_color.lerp(target_fog_color, weight)


func _setup_ground() -> void:
	var ground := StaticBody3D.new()

	var mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(WORLD_SIZE, WORLD_SIZE)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.4, 0.2)
	plane.material = mat
	mesh.mesh = plane
	ground.add_child(mesh)

	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(WORLD_SIZE, 0.2, WORLD_SIZE)
	col.shape = box
	col.position = Vector3(0, -0.1, 0)
	ground.add_child(col)

	add_child(ground)


func _setup_boundaries() -> void:
	# invisible walls so nobody (alive or dead) leaves the field
	var half := WORLD_SIZE / 2.0
	for edge in [
		[Vector3(0, 2, -half), Vector3(WORLD_SIZE, 4, 1)],
		[Vector3(0, 2, half), Vector3(WORLD_SIZE, 4, 1)],
		[Vector3(-half, 2, 0), Vector3(1, 4, WORLD_SIZE)],
		[Vector3(half, 2, 0), Vector3(1, 4, WORLD_SIZE)],
	]:
		var body := StaticBody3D.new()
		var col := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = edge[1]
		col.shape = shape
		body.position = edge[0]
		body.add_child(col)
		add_child(body)


func _scatter_resources() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in 40:
		_place_node("tree", rng)
	for i in 14:
		_place_node("rock", rng)


func _place_node(kind: String, rng: RandomNumberGenerator) -> void:
	var node := ResourceNodeScript.new()
	node.setup(kind)
	var x := rng.randf_range(-35, 35)
	var z := rng.randf_range(-35, 35)
	if Vector2(x, z).length() < 6.0:
		x += 10.0
	node.position = Vector3(x, 0, z)
	add_child(node)


func _spawn_player() -> void:
	player = PlayerScene.instantiate()
	player.position = Vector3(0, 1.5, 0)
	add_child(player)
	_update_health_bar()
	_update_resource_labels()


# ---------------------------------------------------------------- HUD

func _setup_hud() -> void:
	ui = CanvasLayer.new()
	add_child(ui)

	# health bar
	var bar_bg := ColorRect.new()
	bar_bg.color = Color(0.1, 0.1, 0.1, 0.7)
	bar_bg.position = Vector2(16, 16)
	bar_bg.size = Vector2(240, 24)
	bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(bar_bg)

	health_fill = ColorRect.new()
	health_fill.color = Color(0.75, 0.15, 0.15)
	health_fill.position = Vector2(2, 2)
	health_fill.size = Vector2(236, 20)
	health_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar_bg.add_child(health_fill)

	hp_label = _make_label(Vector2(22, 17), "", 15)
	wood_label = _make_label(Vector2(16, 48), "Wood: 0", 18)
	stone_label = _make_label(Vector2(16, 72), "Stone: 0", 18)
	kills_label = _make_label(Vector2(16, 96), "Kills: 0", 18)

	time_label = _make_label(Vector2(0, 14), "", 22)
	time_label.size = Vector2(1280, 30)
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	announce_label = _make_label(Vector2(0, 270), "", 32)
	announce_label.size = Vector2(1280, 60)
	announce_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	build_label = _make_label(Vector2(0, 652), "", 17)
	build_label.size = Vector2(1280, 26)
	build_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	update_build_label(0)

	var hint := _make_label(Vector2(0, 684), "WASD move · Shift sprint · Space jump · Left-click swing · 1/2/3 build · Esc free mouse", 14)
	hint.size = Vector2(1280, 22)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.modulate.a = 0.7

	# crosshair
	var crosshair := ColorRect.new()
	crosshair.color = Color(1, 1, 1, 0.8)
	crosshair.position = Vector2(638, 358)
	crosshair.size = Vector2(4, 4)
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(crosshair)

	# "click to play" prompt — guarantees the window has focus before we grab the mouse
	start_prompt = _make_label(Vector2(0, 320), "▶  CLICK TO PLAY\nWASD move · mouse look · left-click swing · 1/2/3 build", 30)
	start_prompt.size = Vector2(1280, 90)
	start_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	start_prompt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# full-screen red flash for damage
	damage_flash = ColorRect.new()
	damage_flash.color = Color(0.8, 0, 0)
	damage_flash.size = Vector2(1280, 720)
	damage_flash.modulate.a = 0.0
	damage_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(damage_flash)


func _make_label(pos: Vector2, text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(label)
	return label


func hide_start_prompt() -> void:
	if start_prompt:
		start_prompt.visible = false


func announce(message: String) -> void:
	announce_label.text = message
	announce_label.modulate.a = 1.0
	if announce_tween:
		announce_tween.kill()
	announce_tween = create_tween()
	announce_tween.tween_interval(3.5)
	announce_tween.tween_property(announce_label, "modulate:a", 0.0, 1.5)


func _update_time_label() -> void:
	var seconds := int(maxf(phase_time_left, 0.0))
	if phase == Phase.DAY:
		time_label.text = "DAY %d — %ds until nightfall" % [night_number + 1, seconds]
	else:
		var remaining := get_tree().get_nodes_in_group("zombie").size() + spawn_queue.size()
		time_label.text = "NIGHT %d of %d — %ds until dawn — %d dead walking" % [night_number, NIGHTS_TO_WIN, seconds, remaining]


func _update_resource_labels() -> void:
	wood_label.text = "Wood: %d" % resources["wood"]
	stone_label.text = "Stone: %d" % resources["stone"]


func _update_health_bar() -> void:
	if player:
		var ratio: float = clampf(player.hp / player.max_hp, 0.0, 1.0)
		health_fill.size.x = 236.0 * ratio
		hp_label.text = "%d / %d" % [int(player.hp), int(player.max_hp)]


func update_build_label(selection: int) -> void:
	if selection == 0:
		build_label.text = "[1] Wood Wall (5 wood)   [2] Stone Wall (6 stone)   [3] Spike Trap (8 wood)"
	else:
		var b: Dictionary = player.BUILDABLES[selection]
		var costs := []
		for kind in b["cost"]:
			costs.append("%d %s" % [b["cost"][kind], kind])
		build_label.text = "Building: %s (%s) — left-click to place · [Q] put away" % [b["name"], ", ".join(costs)]


func _physics_process(_delta: float) -> void:
	_update_health_bar()


# ---------------------------------------------------------------- end screens

func _show_end_screen(title: String, subtitle: String, title_color: Color) -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var overlay := Control.new()
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay.size = Vector2(1280, 720)
	ui.add_child(overlay)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.75)
	dim.size = Vector2(1280, 720)
	overlay.add_child(dim)

	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.modulate = title_color
	title_label.position = Vector2(0, 240)
	title_label.size = Vector2(1280, 80)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay.add_child(title_label)

	var sub_label := Label.new()
	sub_label.text = subtitle
	sub_label.add_theme_font_size_override("font_size", 22)
	sub_label.position = Vector2(0, 340)
	sub_label.size = Vector2(1280, 80)
	sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay.add_child(sub_label)

	var restart := Button.new()
	restart.text = "  Play Again  "
	restart.add_theme_font_size_override("font_size", 22)
	restart.position = Vector2(565, 450)
	restart.pressed.connect(_on_restart)
	overlay.add_child(restart)


func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
