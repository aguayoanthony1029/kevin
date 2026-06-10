extends StaticBody3D
## A harvestable resource node: a tree (gives wood) or a rock (gives stone).
## Swing your bat at it to harvest. It shrinks as it depletes, then disappears.

var kind: String = "tree"  # "tree" or "rock"
var hits_left: int = 5
var mesh: MeshInstance3D


func setup(new_kind: String) -> void:
	kind = new_kind


func _ready() -> void:
	add_to_group("choppable")
	mesh = MeshInstance3D.new()
	var col := CollisionShape3D.new()

	if kind == "tree":
		var trunk := CylinderMesh.new()
		trunk.top_radius = 0.3
		trunk.bottom_radius = 0.4
		trunk.height = 3.0
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.35, 0.25, 0.15)
		trunk.material = mat
		mesh.mesh = trunk
		mesh.position = Vector3(0, 1.5, 0)

		# a simple canopy so trees read as trees, not pillars
		var canopy := MeshInstance3D.new()
		var leaves := SphereMesh.new()
		leaves.radius = 1.1
		leaves.height = 1.8
		var leaf_mat := StandardMaterial3D.new()
		leaf_mat.albedo_color = Color(0.15, 0.35, 0.12)
		leaves.material = leaf_mat
		canopy.mesh = leaves
		canopy.position = Vector3(0, 3.2, 0)
		add_child(canopy)

		var shape := CylinderShape3D.new()
		shape.radius = 0.4
		shape.height = 3.0
		col.shape = shape
		col.position = Vector3(0, 1.5, 0)
	else:
		var boulder := SphereMesh.new()
		boulder.radius = 0.8
		boulder.height = 1.3
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.45, 0.45, 0.48)
		boulder.material = mat
		mesh.mesh = boulder
		mesh.position = Vector3(0, 0.5, 0)

		var shape := SphereShape3D.new()
		shape.radius = 0.8
		col.shape = shape
		col.position = Vector3(0, 0.5, 0)

	add_child(mesh)
	add_child(col)


## Called by the player's swing. Yields resources and depletes the node.
func chop(world) -> void:
	hits_left -= 1
	world.add_resource("wood" if kind == "tree" else "stone", 2)
	# shrink a little with each hit so progress is visible
	var t := create_tween()
	t.tween_property(self, "scale", scale * 0.92, 0.1)
	if hits_left <= 0:
		collision_layer = 0
		remove_from_group("choppable")
		var out := create_tween()
		out.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.25)
		out.tween_callback(queue_free)
