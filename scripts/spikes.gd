extends Area3D
## A floor spike trap. Zombies walk over it and bleed for every moment they
## stand on it. Wears out with use — each bite costs the trap durability.

const DAMAGE_PER_TICK := 7.0
const TICK_INTERVAL := 0.5
const MAX_DURABILITY := 30

var durability: int = MAX_DURABILITY
var tick_timer: float = 0.0
var mat: StandardMaterial3D


func _ready() -> void:
	monitoring = true

	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(2.0, 0.35, 2.0)
	mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.55, 0.45, 0.3)
	mat.metallic = 0.4
	box.material = mat
	mesh.mesh = box
	mesh.position = Vector3(0, 0.18, 0)
	add_child(mesh)

	# a few visible spike points
	for offset in [Vector3(-0.6, 0, -0.6), Vector3(0.6, 0, -0.6), Vector3(0, 0, 0), Vector3(-0.6, 0, 0.6), Vector3(0.6, 0, 0.6)]:
		var spike := MeshInstance3D.new()
		var cone := CylinderMesh.new()
		cone.top_radius = 0.0
		cone.bottom_radius = 0.12
		cone.height = 0.5
		var spike_mat := StandardMaterial3D.new()
		spike_mat.albedo_color = Color(0.7, 0.7, 0.72)
		spike_mat.metallic = 0.8
		cone.material = spike_mat
		spike.mesh = cone
		spike.position = offset + Vector3(0, 0.55, 0)
		add_child(spike)

	var col := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 1.0, 2.0)
	col.shape = shape
	col.position = Vector3(0, 0.5, 0)
	add_child(col)


func _physics_process(delta: float) -> void:
	tick_timer -= delta
	if tick_timer > 0.0:
		return
	tick_timer = TICK_INTERVAL

	for body in get_overlapping_bodies():
		if body.is_in_group("zombie"):
			body.take_damage(DAMAGE_PER_TICK)
			durability -= 1
			# rust over as it wears out
			mat.albedo_color = mat.albedo_color.lerp(Color(0.35, 0.2, 0.12), 0.06)
			if durability <= 0:
				var t := create_tween()
				t.tween_property(self, "scale", Vector3(1.0, 0.02, 1.0), 0.3)
				t.tween_callback(queue_free)
				set_physics_process(false)
				return
