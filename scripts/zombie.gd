extends CharacterBody3D
## The dead. Three breeds, all built in code:
##  - walker: slow, steady, the classic shambler. The bread and butter of the horde.
##  - runner: fast and fragile. Forces you to turn and fight.
##  - brute:  huge, slow, and a wall-smasher. Your base's worst nightmare.
##
## AI is intentionally simple and honest: walk at the player. If something you
## built is in the way, break it. That's all a horde needs to be terrifying.

const BREEDS := {
	"walker": {
		"speed": 1.7, "hp": 60.0, "damage": 10.0, "wall_damage": 14.0,
		"color": Color(0.45, 0.55, 0.4), "height": 1.8, "radius": 0.4, "attack_cooldown": 1.1,
	},
	"runner": {
		"speed": 4.2, "hp": 30.0, "damage": 8.0, "wall_damage": 8.0,
		"color": Color(0.6, 0.35, 0.3), "height": 1.6, "radius": 0.32, "attack_cooldown": 0.8,
	},
	"brute": {
		"speed": 1.2, "hp": 220.0, "damage": 25.0, "wall_damage": 55.0,
		"color": Color(0.3, 0.32, 0.28), "height": 2.6, "radius": 0.65, "attack_cooldown": 1.6,
	},
}

const GRAVITY := 14.0

var breed: String = "walker"
var hp: float = 60.0
var stats: Dictionary
var attack_timer: float = 0.0
var wander_offset: float = 0.0
var dead: bool = false

var body_mat: StandardMaterial3D
var flash_tween: Tween
var world  # set by world.gd when spawned


func setup(new_breed: String) -> void:
	breed = new_breed
	stats = BREEDS[breed]
	hp = stats["hp"]


func _ready() -> void:
	add_to_group("zombie")
	# each zombie drifts slightly off the straight line so hordes spread out
	wander_offset = randf_range(-0.35, 0.35)

	var height: float = stats["height"]
	var radius: float = stats["radius"]

	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.height = height
	capsule.radius = radius
	collision.shape = capsule
	collision.position = Vector3(0, height / 2.0, 0)
	add_child(collision)

	var mesh := MeshInstance3D.new()
	var capsule_mesh := CapsuleMesh.new()
	capsule_mesh.height = height
	capsule_mesh.radius = radius
	body_mat = StandardMaterial3D.new()
	body_mat.albedo_color = stats["color"]
	capsule_mesh.material = body_mat
	mesh.mesh = capsule_mesh
	mesh.position = Vector3(0, height / 2.0, 0)
	add_child(mesh)

	# glowing red eyes — so the night feels like the ads
	for side in [-1.0, 1.0]:
		var eye := MeshInstance3D.new()
		var eye_mesh := SphereMesh.new()
		eye_mesh.radius = 0.05
		eye_mesh.height = 0.1
		var eye_mat := StandardMaterial3D.new()
		eye_mat.albedo_color = Color(1, 0, 0)
		eye_mat.emission_enabled = true
		eye_mat.emission = Color(1, 0.1, 0.1)
		eye_mat.emission_energy_multiplier = 2.5
		eye_mesh.material = eye_mat
		eye.mesh = eye_mesh
		eye.position = Vector3(side * 0.13, height - 0.25, -radius + 0.02)
		add_child(eye)


func _physics_process(delta: float) -> void:
	if dead:
		return
	attack_timer = maxf(attack_timer - delta, 0.0)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var player = world.player if world else null
	if player == null or not is_instance_valid(player):
		return

	# face and chase the player, with a little per-zombie drift
	var to_player: Vector3 = player.global_position - global_position
	to_player.y = 0.0
	if to_player.length() < 0.05:
		move_and_slide()
		return
	var direction := to_player.normalized().rotated(Vector3.UP, wander_offset)
	look_at(global_position + to_player.normalized(), Vector3.UP)

	var speed: float = stats["speed"]
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

	# whatever we bumped into: bite the player, or smash the structure
	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		if collider == null or attack_timer > 0.0:
			continue
		if collider.is_in_group("player"):
			collider.take_damage(stats["damage"])
			attack_timer = stats["attack_cooldown"]
		elif collider.is_in_group("structure"):
			collider.take_hit(stats["wall_damage"])
			attack_timer = stats["attack_cooldown"]
			_lunge_flash()


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
	body_mat.albedo_color = Color(1, 1, 1)
	flash_tween = create_tween()
	flash_tween.tween_property(body_mat, "albedo_color", stats["color"], 0.18)


func _lunge_flash() -> void:
	# tiny scale pulse when smashing a wall, so attacks read visually
	if flash_tween:
		flash_tween.kill()
	scale = Vector3.ONE * 1.08
	flash_tween = create_tween()
	flash_tween.tween_property(self, "scale", Vector3.ONE, 0.2)


func _die() -> void:
	dead = true
	remove_from_group("zombie")
	collision_layer = 0
	collision_mask = 0
	if world:
		world.on_zombie_killed()
	var t := create_tween()
	t.tween_property(self, "scale", Vector3(1.0, 0.05, 1.0), 0.35)  # crumple
	t.tween_callback(queue_free)
