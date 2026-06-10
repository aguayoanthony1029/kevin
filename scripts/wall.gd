extends StaticBody3D
## A player-built defensive wall. Wood is cheap but weak; stone holds the line.
## Zombies attack these — when hp hits zero, the wall crumbles.

const KINDS := {
	"wood":  {"hp": 150.0, "color": Color(0.5, 0.36, 0.2)},
	"stone": {"hp": 380.0, "color": Color(0.5, 0.5, 0.55)},
}

const SIZE := Vector3(2.0, 2.2, 0.4)

var kind: String = "wood"
var hp: float = 150.0
var max_hp: float = 150.0
var mat: StandardMaterial3D
var flash_tween: Tween


func setup(new_kind: String) -> void:
	kind = new_kind
	max_hp = KINDS[kind]["hp"]
	hp = max_hp


func _ready() -> void:
	add_to_group("structure")

	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = SIZE
	mat = StandardMaterial3D.new()
	mat.albedo_color = KINDS[kind]["color"]
	box.material = mat
	mesh.mesh = box
	mesh.position = Vector3(0, SIZE.y / 2.0, 0)
	add_child(mesh)

	var col := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = SIZE
	col.shape = shape
	col.position = Vector3(0, SIZE.y / 2.0, 0)
	add_child(col)


func take_hit(amount: float) -> void:
	hp -= amount
	# flash, and darken permanently as it gets more beaten up
	if flash_tween:
		flash_tween.kill()
	mat.albedo_color = Color(1, 0.4, 0.3)
	var damaged_color: Color = KINDS[kind]["color"] * clampf(0.45 + 0.55 * (hp / max_hp), 0.45, 1.0)
	flash_tween = create_tween()
	flash_tween.tween_property(mat, "albedo_color", damaged_color, 0.25)

	if hp <= 0.0:
		collision_layer = 0
		remove_from_group("structure")
		var t := create_tween()
		t.tween_property(self, "scale", Vector3(1.0, 0.05, 1.0), 0.3)
		t.tween_callback(queue_free)
