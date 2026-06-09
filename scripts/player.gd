extends CharacterBody3D
## First-person player controller for UNDYING.
##
## Everything (collision, body mesh, camera) is built in code in _ready() so the
## project "just runs" with no manual node wiring. As you learn, we'll move these
## into the editor as proper child nodes — but for now, this gets you walking.
##
## Controls: WASD move · mouse look · Shift sprint · Space jump · Esc free the mouse.

const SPEED: float = 5.0
const SPRINT_SPEED: float = 8.0
const JUMP_VELOCITY: float = 4.5
const GRAVITY: float = 14.0
const MOUSE_SENSITIVITY: float = 0.003

var camera: Camera3D
var pitch: float = 0.0  # up/down look angle, in radians


func _ready() -> void:
	# --- Collision shape (a capsule, like most humanoid characters) ---
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.height = 1.8
	capsule.radius = 0.4
	collision.shape = capsule
	collision.position = Vector3(0, 0.9, 0)  # lift so the capsule sits on the ground
	add_child(collision)

	# --- Visible body (you won't see much in first person, but it casts a shadow) ---
	var body := MeshInstance3D.new()
	var body_mesh := CapsuleMesh.new()
	body_mesh.height = 1.8
	body_mesh.radius = 0.4
	body.mesh = body_mesh
	body.position = Vector3(0, 0.9, 0)
	add_child(body)

	# --- Camera at roughly eye height ---
	camera = Camera3D.new()
	camera.position = Vector3(0, 1.6, 0)
	camera.current = true
	add_child(camera)

	# Grab the mouse so moving it looks around instead of moving a cursor.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)          # turn the body left/right
		pitch = clampf(pitch - event.relative.y * MOUSE_SENSITIVITY, -1.4, 1.4)
		camera.rotation.x = pitch                                 # tilt the camera up/down

	# Press Esc to release/recapture the mouse (handy when alt-tabbing)
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Gravity pulls us down when we're not standing on something.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Jump
	if Input.is_physical_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Read movement keys. "physical" keys means it works on any keyboard layout.
	var input_dir := Vector3.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input_dir.z -= 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.z += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0

	# Move relative to where we're facing (so "W" is always "forward").
	var direction := (transform.basis * input_dir).normalized()
	var speed := SPRINT_SPEED if Input.is_physical_key_pressed(KEY_SHIFT) else SPEED
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
