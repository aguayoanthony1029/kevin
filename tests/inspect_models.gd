extends SceneTree
## Prints the node tree and animation list of each imported zombie FBX so we
## know exactly what we're wiring into the game.

const FILES := [
	"res://assets/models/zombie/zombie_char_a.fbx",
	"res://assets/models/zombie/zombie_char_b.fbx",
	"res://assets/models/zombie/anims/zombie_walk.fbx",
	"res://assets/models/zombie/anims/zombie_attack.fbx",
	"res://assets/models/zombie/anims/zombie_death.fbx",
	"res://assets/models/zombie/anims/zombie_idle.fbx",
	"res://assets/models/zombie/anims/zombie_run.fbx",
	"res://assets/models/zombie/anims/zombie_scream.fbx",
]


func _initialize() -> void:
	for path in FILES:
		print("\n=== ", path.get_file(), " ===")
		var scene = load(path)
		if scene == null:
			print("  LOAD FAILED")
			continue
		var inst = scene.instantiate()
		_dump(inst, 1)
		inst.free()
	quit(0)


func _dump(node: Node, depth: int) -> void:
	var pad := "  ".repeat(depth)
	var extra := ""
	if node is AnimationPlayer:
		var names := []
		for anim_name in node.get_animation_list():
			names.append("%s (%.2fs)" % [anim_name, node.get_animation(anim_name).length])
		extra = "  anims: " + str(names)
	if node is Skeleton3D:
		extra = "  bones: %d (root: %s)" % [node.get_bone_count(), node.get_bone_name(0)]
	if node is MeshInstance3D:
		extra = "  surfaces: %d" % node.mesh.get_surface_count() if node.mesh else "  no mesh"
	print(pad, node.name, " [", node.get_class(), "]", extra)
	if depth < 3:
		for child in node.get_children():
			_dump(child, depth + 1)
