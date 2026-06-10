extends CharacterBody3D
## The dead. Three breeds, each an animated humanoid built in code:
##  - walker: slow, hunched, arms reaching. The classic shambler.
##  - runner: lean and fast. Forces you to turn and fight.
##  - brute:  huge, slow, a wall-smasher. Your base's worst nightmare.
##
## Each zombie is a little figure — head, torso, two arms, two legs — that
## actually walks (legs and arms swing) and lunges when it attacks. Gritty,
## rotting materials and glowing eyes sell the horror.

const BREEDS := {
	"walker": {
		"speed": 1.7, "hp": 60.0, "damage": 10.0, "wall_damage": 14.0,
		"skin": Color(0.46, 0.52, 0.40), "cloth": Color(0.20, 0.22, 0.19),
		"height": 1.8, "radius": 0.4, "attack_cooldown": 1.1, "gait": 2.4,
	},
	"runner": {
		"speed": 4.2, "hp": 30.0, "damage": 8.0, "wall_damage": 8.0,
		"skin": Color(0.58, 0.42, 0.39), "cloth": Color(0.30, 0.16, 0.15),
		"height": 1.7, "radius": 0.32, "attack_cooldown": 0.8, "gait": 5.5,
	},
	"brute": {
		"speed": 1.2, "hp": 220.0, "damage": 25.0, "wall_damage": 55.0,
		"skin": Color(0.42, 0.46, 0.42), "cloth": Color(0.18, 0.19, 0.20),
		"height": 2.5, "radius": 0.6, "attack_cooldown": 1.6, "gait": 1.8,
	},
}

const GRAVITY := 14.0

var breed: String = "walker"
var hp: float = 60.0
var stats: Dictionary
var attack_timer: float = 0.0
var wander_offset: float = 0.0
var dead: bool = false
var moving: bool = false

# animated body parts
var visual: Node3D
var upper: Node3D
var hip_l: Node3D
var hip_r: Node3D
var sh_l: Node3D
var sh_r: Node3D
var anim_phase: float = 0.0
var lunge: float = 0.0  # 0..1, drives the attack reach

var skin_mat: StandardMaterial3D
var flash_tween: Tween
var world  # set by world.gd when spawned


func setup(new_breed: String) -> void:
	breed = new_breed
	stats = BREEDS[breed]
	hp = stats["hp"]


func _ready() -> void:
	add_to_group("zombie")
	wander_offset = randf_range(-0.35, 0.35)
	anim_phase = randf() * TAU  # so the horde isn't in lock-step

	var h: float = stats["height"]
	var r: float = stats["radius"]

	# physics body (a simple capsule — never seen, just for collisions)
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.height = h
	capsule.radius = r
	collision.shape = capsule
	collision.position = Vector3(0, h / 2.0, 0)
	add_child(collision)

	_build_humanoid(h, r)


func _build_humanoid(h: float, r: float) -> void:
	var skin: Color = stats["skin"]
	var cloth: Color = stats["cloth"]

	skin_mat = _matte(skin)
	var cloth_mat := _matte(cloth)

	# proportions, derived from height
	var hip_y := h * 0.48
	var shoulder_y := h * 0.82
	var leg_len := hip_y
	var torso_h := shoulder_y - hip_y
	var arm_len := h * 0.42
	var limb_w := r * 0.7
	var hip_dx := r * 0.45
	var sh_dx := r * 0.95

	visual = Node3D.new()
	add_child(visual)

	# --- legs (swing from the hips) ---
	hip_l = _joint(Vector3(-hip_dx, hip_y, 0))
	hip_r = _joint(Vector3(hip_dx, hip_y, 0))
	visual.add_child(hip_l)
	visual.add_child(hip_r)
	_limb(hip_l, Vector3(limb_w, leg_len, limb_w), -leg_len / 2.0, cloth_mat)
	_limb(hip_r, Vector3(limb_w, leg_len, limb_w), -leg_len / 2.0, cloth_mat)

	# --- upper body (hunched forward) ---
	upper = _joint(Vector3(0, hip_y, 0))
	visual.add_child(upper)

	var torso := MeshInstance3D.new()
	var torso_mesh := BoxMesh.new()
	torso_mesh.size = Vector3(r * 1.6, torso_h, r * 0.9)
	torso_mesh.material = cloth_mat
	torso.mesh = torso_mesh
	torso.position = Vector3(0, torso_h / 2.0, 0)
	upper.add_child(torso)

	var head := MeshInstance3D.new()
	var head_mesh := BoxMesh.new()
	head_mesh.size = Vector3(r * 0.95, r * 1.05, r * 0.95)
	head_mesh.material = skin_mat
	head.mesh = head_mesh
	head.position = Vector3(0, torso_h + r * 0.55, r * 0.05)
	upper.add_child(head)

	# glowing eyes
	for side in [-1.0, 1.0]:
		var eye := MeshInstance3D.new()
		var eye_mesh := BoxMesh.new()
		eye_mesh.size = Vector3(r * 0.18, r * 0.12, r * 0.05)
		var eye_mat := StandardMaterial3D.new()
		eye_mat.albedo_color = Color(1, 0.1, 0.1)
		eye_mat.emission_enabled = true
		eye_mat.emission = Color(1, 0.08, 0.08)
		eye_mat.emission_energy_multiplier = 3.0
		eye_mesh.material = eye_mat
		eye.mesh = eye_mesh
		eye.position = Vector3(side * r * 0.25, torso_h + r * 0.6, -r * 0.45)
		upper.add_child(eye)

	# --- arms (reach forward, the classic zombie pose) ---
	sh_l = _joint(Vector3(-sh_dx, torso_h, 0))
	sh_r = _joint(Vector3(sh_dx, torso_h, 0))
	upper.add_child(sh_l)
	upper.add_child(sh_r)
	_limb(sh_l, Vector3(limb_w, arm_len, limb_w), -arm_len / 2.0, skin_mat)
	_limb(sh_r, Vector3(limb_w, arm_len, limb_w), -arm_len / 2.0, skin_mat)


func _joint(pos: Vector3) -> Node3D:
	var n := Node3D.new()
	n.position = pos
	return n


func _limb(joint: Node3D, size: Vector3, y_offset: float, mat: StandardMaterial3D) -> void:
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	box.material = mat
	mesh.mesh = box
	mesh.position = Vector3(0, y_offset, 0)
	joint.add_child(mesh)


func _matte(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.95
	m.metallic = 0.0
	return m


func _physics_process(delta: float) -> void:
	if dead:
		return
	attack_timer = maxf(attack_timer - delta, 0.0)
	lunge = maxf(lunge - delta * 3.0, 0.0)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var player = world.player if world else null
	if player == null or not is_instance_valid(player):
		_animate(delta)
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

	moving = Vector2(velocity.x, velocity.z).length() > 0.3
	_animate(delta)

	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		if collider == null or attack_timer > 0.0:
			continue
		if collider.is_in_group("player"):
			collider.take_damage(stats["damage"])
			attack_timer = stats["attack_cooldown"]
			lunge = 1.0
		elif collider.is_in_group("structure"):
			collider.take_hit(stats["wall_damage"])
			attack_timer = stats["attack_cooldown"]
			lunge = 1.0


func _animate(delta: float) -> void:
	if visual == null:
		return
	var gait: float = stats["gait"]
	if moving:
		anim_phase += delta * gait

	# legs stride, opposite phase
	var swing := 0.7 if moving else 0.0
	hip_l.rotation.x = sin(anim_phase) * swing
	hip_r.rotation.x = sin(anim_phase + PI) * swing

	# hunch forward; sway side to side as it shambles
	upper.rotation.x = 0.28
	upper.rotation.z = sin(anim_phase) * 0.06

	# arms reach forward (+x rotation = forward toward -Z), with a creepy sway,
	# and snap further out when lunging to attack
	var reach := 1.25 + lunge * 0.7
	sh_l.rotation.x = reach + sin(anim_phase + PI) * 0.12
	sh_r.rotation.x = reach + sin(anim_phase) * 0.12


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
	skin_mat.albedo_color = Color(1, 1, 1)
	flash_tween = create_tween()
	flash_tween.tween_property(skin_mat, "albedo_color", stats["skin"], 0.18)


func _die() -> void:
	dead = true
	remove_from_group("zombie")
	collision_layer = 0
	collision_mask = 0
	if world:
		world.on_zombie_killed()
	var t := create_tween()
	t.set_parallel(true)
	t.tween_property(visual, "rotation_degrees", Vector3(-85, visual.rotation_degrees.y, 0), 0.4)  # fall over
	t.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0) * 0.9, 0.4)
	t.chain().tween_interval(0.6)
	t.chain().tween_callback(queue_free)
