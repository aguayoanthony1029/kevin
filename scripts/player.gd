extends CharacterBody3D
## UNDYING's survivor — first person, built entirely in code.
##
## Controls:
##   WASD move · mouse look · Shift sprint · Space jump · Esc free the mouse
##   Left-click  — swing your bat (hits zombies, chops trees, mines rocks)
##   1 / 2 / 3   — select buildable (wood wall / stone wall / spike trap)
##   Left-click  — place the selected buildable (while in build mode)
##   Q           — put the blueprint away

const SPEED := 5.0
const SPRINT_SPEED := 8.0
const JUMP_VELOCITY := 4.5
const GRAVITY := 14.0
const MOUSE_SENSITIVITY := 0.003

const MELEE_RANGE := 2.7
const MELEE_DAMAGE := 35.0
const MELEE_COOLDOWN := 0.45
const BUILD_DISTANCE := 3.5
const GRID := 2.0
const DAY_REGEN_PER_SEC := 2.0

const WallScript := preload("res://scripts/wall.gd")
const SpikesScript := preload("res://scripts/spikes.gd")

const BUILDABLES := {
	KEY_1: {"name": "Wood Wall", "cost": {"wood": 5}},
	KEY_2: {"name": "Stone Wall", "cost": {"stone": 6}},
	KEY_3: {"name": "Spike Trap", "cost": {"wood": 8}},
}

var max_hp := 100.0
var hp := 100.0

var camera: Camera3D
var bat: MeshInstance3D
var pitch := 0.0
var swing_timer := 0.0
var swing_tween: Tween
var started := false
var pending_swing := false
var pending_place := false

var build_selection: int = 0  # 0 = not building, otherwise a KEY_* constant
var ghost: MeshInstance3D
var ghost_mat: StandardMaterial3D

var world  # the Main node (world.gd); set in _ready


func _ready() -> void:
	add_to_group("player")
	world = get_parent()

	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.height = 1.8
	capsule.radius = 0.4
	collision.shape = capsule
	collision.position = Vector3(0, 0.9, 0)
	add_child(collision)

	camera = Camera3D.new()
	camera.position = Vector3(0, 1.6, 0)
	camera.current = true
	add_child(camera)

	# the trusty bat, visible at the edge of your view
	bat = MeshInstance3D.new()
	var bat_mesh := BoxMesh.new()
	bat_mesh.size = Vector3(0.07, 0.07, 0.75)
	var bat_mat := StandardMaterial3D.new()
	bat_mat.albedo_color = Color(0.45, 0.3, 0.18)
	bat_mesh.material = bat_mat
	bat.mesh = bat_mesh
	bat.position = Vector3(0.35, -0.28, -0.55)
	bat.rotation_degrees = Vector3(-10, 15, 0)
	camera.add_child(bat)

	# translucent build preview (hidden until you pick a buildable)
	ghost = MeshInstance3D.new()
	ghost.mesh = BoxMesh.new()
	ghost_mat = StandardMaterial3D.new()
	ghost_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ghost_mat.albedo_color = Color(0.3, 1.0, 0.4, 0.35)
	ghost.visible = false
	world.add_child.call_deferred(ghost)

	# Start with the cursor free. We only grab the mouse once the player clicks
	# the window — this guarantees the game window has keyboard focus, which is
	# the usual reason WASD "does nothing" right after launch.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		pitch = clampf(pitch - event.relative.y * MOUSE_SENSITIVITY, -1.4, 1.4)
		camera.rotation.x = pitch

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				else:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			KEY_Q:
				_set_build_selection(0)
			KEY_1, KEY_2, KEY_3:
				# pressing the same key again puts the blueprint away
				_set_build_selection(0 if build_selection == event.keycode else event.keycode)

	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			# First click: focus the window and grab the mouse to start playing.
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			started = true
			world.hide_start_prompt()
			return
		# Defer the actual action to the physics step so ray queries are safe.
		if build_selection != 0:
			pending_place = true
		else:
			pending_swing = true


func _physics_process(delta: float) -> void:
	swing_timer = maxf(swing_timer - delta, 0.0)

	# daylight slowly knits your wounds — survive the night, heal in the sun
	if world.phase == world.Phase.DAY and hp < max_hp:
		hp = minf(hp + DAY_REGEN_PER_SEC * delta, max_hp)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	if Input.is_physical_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Vector3.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input_dir.z -= 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.z += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0

	var direction := (transform.basis * input_dir).normalized()
	var speed := SPRINT_SPEED if Input.is_physical_key_pressed(KEY_SHIFT) else SPEED
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

	if build_selection != 0:
		_update_ghost()

	# Handle deferred clicks here, where physics ray queries are safe to run.
	if pending_swing:
		pending_swing = false
		_swing()
	if pending_place:
		pending_place = false
		_try_place()


# ---------------------------------------------------------------- combat

func _swing() -> void:
	if swing_timer > 0.0:
		return
	swing_timer = MELEE_COOLDOWN

	# bat swing animation
	if swing_tween:
		swing_tween.kill()
	bat.rotation_degrees = Vector3(-10, 15, 0)
	swing_tween = create_tween()
	swing_tween.tween_property(bat, "rotation_degrees", Vector3(-80, 35, 0), 0.1)
	swing_tween.tween_property(bat, "rotation_degrees", Vector3(-10, 15, 0), 0.2)

	# what did we hit? cast a ray from the center of the screen
	var from := camera.global_position
	var to := from + (-camera.global_transform.basis.z) * MELEE_RANGE
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [get_rid()]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return

	var target = hit["collider"]
	if target.is_in_group("zombie"):
		target.take_damage(MELEE_DAMAGE)
	elif target.is_in_group("choppable"):
		target.chop(world)


func take_damage(amount: float) -> void:
	hp -= amount
	world.on_player_damaged()
	if hp <= 0.0:
		hp = 0.0
		world.game_over()


# ---------------------------------------------------------------- building

func _set_build_selection(keycode: int) -> void:
	build_selection = keycode
	ghost.visible = build_selection != 0
	if build_selection != 0:
		if build_selection == KEY_3:
			var pad := BoxMesh.new()
			pad.size = Vector3(2.0, 0.35, 2.0)
			ghost.mesh = pad
		else:
			var box := BoxMesh.new()
			box.size = WallScript.SIZE
			ghost.mesh = box
		ghost.mesh.material = ghost_mat
	world.update_build_label(build_selection)


func _build_position() -> Vector3:
	var forward := -global_transform.basis.z
	var spot := global_position + forward * BUILD_DISTANCE
	return Vector3(snappedf(spot.x, GRID), 0.0, snappedf(spot.z, GRID))


func _snapped_yaw() -> float:
	return snappedf(rotation.y, PI / 2.0)


func _update_ghost() -> void:
	var pos := _build_position()
	ghost.position = pos + Vector3(0, 0.18 if build_selection == KEY_3 else WallScript.SIZE.y / 2.0, 0)
	ghost.rotation.y = _snapped_yaw()
	var affordable: bool = world.can_afford(BUILDABLES[build_selection]["cost"])
	ghost_mat.albedo_color = Color(0.3, 1.0, 0.4, 0.35) if affordable else Color(1.0, 0.25, 0.2, 0.35)


func _try_place() -> void:
	var cost: Dictionary = BUILDABLES[build_selection]["cost"]
	if not world.try_spend(cost):
		return

	var built: Node3D
	if build_selection == KEY_3:
		built = SpikesScript.new()
	else:
		built = WallScript.new()
		built.setup("wood" if build_selection == KEY_1 else "stone")
	built.position = _build_position()
	built.rotation.y = _snapped_yaw()
	world.add_child(built)
