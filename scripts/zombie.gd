extends CharacterBody3D
## The dead — real rigged Mixamo characters with skeletal animations.
##  - walker: the classic shambler (FuzZombie model, zombie walk)
##  - runner: fast and vicious (ZombieGirl model, zombie run)
##  - brute:  a hulking, darkened wall-smasher (scaled FuzZombie, heavy walk)
##
## AI stays honest and simple: walk at the player; if something you built is in
## the way, smash it. Animations: walk/run while moving, bite on attack, a real
## death animation, then the corpse sinks away.

const CHAR_A := "res://assets/models/zombie/zombie_char_a.fbx"
const CHAR_B := "res://assets/models/zombie/zombie_char_b.fbx"

const ANIM_FILES := {
	"walk": "res://assets/models/zombie/anims/zombie_walk.fbx",
	"run": "res://assets/models/zombie/anims/zombie_run.fbx",
	"attack": "res://assets/models/zombie/anims/zombie_attack.fbx",
	"death": "res://assets/models/zombie/anims/zombie_death.fbx",
	"idle": "res://assets/models/zombie/anims/zombie_idle.fbx",
	"scream": "res://assets/models/zombie/anims/zombie_scream.fbx",
}

const BREEDS := {
	"walker": {
		"speed": 1.7, "hp": 60.0, "damage": 10.0, "wall_damage": 14.0,
		"height": 1.8, "radius": 0.4, "attack_cooldown": 1.3,
		"model": CHAR_A, "move_anim": "walk", "anim_speed": 1.0, "tint": Color(1, 1, 1),
	},
	"runner": {
		"speed": 4.2, "hp": 30.0, "damage": 8.0, "wall_damage": 8.0,
		"height": 1.7, "radius": 0.32, "attack_cooldown": 0.9,
		"model": CHAR_B, "move_anim": "run", "anim_speed": 1.1, "tint": Color(1, 1, 1),
	},
	"brute": {
		"speed": 1.2, "hp": 220.0, "damage": 25.0, "wall_damage": 55.0,
		"height": 2.4, "radius": 0.6, "attack_cooldown": 1.8,
		"model": CHAR_A, "move_anim": "walk", "anim_speed": 0.7, "tint": Color(0.45, 0.5, 0.45),
	},
}

const GRAVITY := 14.0

# the animation library is built once and shared by every zombie
static var _shared_lib: AnimationLibrary

var breed: String = "walker"
var hp: float = 60.0
var stats: Dictionary
var attack_timer: float = 0.0
var wander_offset: float = 0.0
var dead: bool = false
var attacking: bool = false

var model: Node3D
var anim_player: AnimationPlayer
var mats: Array[StandardMaterial3D] = []       # body materials (flash on hit)
var eye_mats: Array[StandardMaterial3D] = []   # eye materials (always glow)
var flash_tween: Tween
var world  # set by world.gd when spawned


func setup(new_breed: String) -> void:
	breed = new_breed
	stats = BREEDS[breed]
	hp = stats["hp"]


static func _build_shared_library() -> AnimationLibrary:
	var lib := AnimationLibrary.new()
	for anim_name in ANIM_FILES:
		var scene: PackedScene = load(ANIM_FILES[anim_name])
		if scene == null:
			continue
		var inst := scene.instantiate()
		var player: AnimationPlayer = inst.find_child("AnimationPlayer", true, false)
		if player and player.has_animation("mixamo_com"):
			var anim := player.get_animation("mixamo_com").duplicate()
			if anim_name in ["walk", "run", "idle"]:
				anim.loop_mode = Animation.LOOP_LINEAR
			lib.add_animation(anim_name, anim)
		inst.free()
	return lib


func _ready() -> void:
	add_to_group("zombie")
	wander_offset = randf_range(-0.35, 0.35)

	var h: float = stats["height"]
	var r: float = stats["radius"]

	# physics capsule (never seen; just collisions)
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.height = h
	capsule.radius = r
	collision.shape = capsule
	collision.position = Vector3(0, h / 2.0, 0)
	add_child(collision)

	# --- the rigged character model ---
	model = (load(stats["model"]) as PackedScene).instantiate()
	add_child(model)
	_fit_model_to_height(h)
	_setup_materials(stats["tint"])

	# --- animations: transplant the shared Mixamo library onto this model ---
	if _shared_lib == null:
		_shared_lib = _build_shared_library()
	anim_player = model.find_child("AnimationPlayer", true, false)
	if anim_player:
		anim_player.add_animation_library("z", _shared_lib)
		anim_player.animation_finished.connect(_on_anim_finished)
		_play_move_anim()
	# desync the horde so they don't move in lock-step
	if anim_player:
		anim_player.seek(randf() * 2.0, true)


func _fit_model_to_height(target_height: float) -> void:
	# measure the model's bounding box and scale it to the breed's height
	var combined := AABB()
	var has_any := false
	for mi in model.find_children("*", "MeshInstance3D", true, false):
		var ab: AABB = mi.get_aabb()
		ab = mi.transform * ab
		if has_any:
			combined = combined.merge(ab)
		else:
			combined = ab
			has_any = true
	if not has_any or combined.size.y < 0.01:
		return
	var s := target_height / combined.size.y
	model.scale = Vector3.ONE * s
	model.position.y = -combined.position.y * s


func _setup_materials(tint: Color) -> void:
	# give each zombie its own materials so tints and hit-flashes don't bleed
	# across the horde; make any "Eyes" mesh glow red for the night
	for mi in model.find_children("*", "MeshInstance3D", true, false):
		if mi.mesh == null:
			continue
		# the FuzZombie ships with a glass dome that imports as an opaque white
		# shell — hide it
		if String(mi.name).to_lower().contains("glass"):
			mi.visible = false
			continue
		for i in mi.mesh.get_surface_count():
			var m: Material = mi.get_active_material(i)
			if m is StandardMaterial3D:
				var dup: StandardMaterial3D = m.duplicate()
				dup.albedo_color = dup.albedo_color * tint
				dup.roughness = 0.95
				mi.set_surface_override_material(i, dup)
				if String(mi.name).to_lower().contains("eye"):
					dup.emission_enabled = true
					dup.emission = Color(0.9, 0.05, 0.05)
					dup.emission_energy_multiplier = 1.6
					eye_mats.append(dup)
				else:
					mats.append(dup)


func _play_move_anim() -> void:
	if anim_player:
		anim_player.play("z/" + stats["move_anim"], 0.3, stats["anim_speed"])


func _physics_process(delta: float) -> void:
	if dead:
		return
	attack_timer = maxf(attack_timer - delta, 0.0)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var player = world.player if world else null
	if player == null or not is_instance_valid(player):
		move_and_slide()
		return

	var to_player: Vector3 = player.global_position - global_position
	to_player.y = 0.0
	if to_player.length() > 0.05:
		var direction := to_player.normalized().rotated(Vector3.UP, wander_offset)
		look_at(global_position + to_player.normalized(), Vector3.UP)
		var speed: float = stats["speed"]
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		if collider == null or attack_timer > 0.0:
			continue
		if collider.is_in_group("player"):
			collider.take_damage(stats["damage"])
			_attack_anim()
		elif collider.is_in_group("structure"):
			collider.take_hit(stats["wall_damage"])
			_attack_anim()


func _attack_anim() -> void:
	attack_timer = stats["attack_cooldown"]
	if anim_player and not attacking:
		attacking = true
		anim_player.play("z/attack", 0.15, 1.8)


func _on_anim_finished(anim_name: StringName) -> void:
	if dead:
		return
	if attacking and String(anim_name) == "z/attack":
		attacking = false
		_play_move_anim()


func take_damage(amount: float) -> void:
	if dead:
		return
	hp -= amount
	_hit_flash()
	if hp <= 0.0:
		_die()


func _hit_flash() -> void:
	if flash_tween:
		flash_tween.kill()
	for m in mats:
		m.emission_enabled = true
		m.emission = Color(1, 0.15, 0.1)
	flash_tween = create_tween()
	flash_tween.tween_method(_set_flash_energy, 1.0, 0.0, 0.22)


func _set_flash_energy(value: float) -> void:
	for m in mats:
		m.emission_energy_multiplier = value
		if value <= 0.01:
			m.emission_enabled = false


func _die() -> void:
	dead = true
	remove_from_group("zombie")
	collision_layer = 0
	collision_mask = 0
	velocity = Vector3.ZERO
	if world:
		world.on_zombie_killed()
	if anim_player:
		anim_player.play("z/death", 0.1, 1.2)
	var t := create_tween()
	t.tween_interval(2.8)
	t.tween_property(self, "position:y", position.y - 1.5, 1.4)
	t.tween_callback(queue_free)
