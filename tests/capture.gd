extends SceneTree
## Boots the real game under a virtual display, lets it render a few seconds,
## simulates a moment of WASD movement to verify the controller actually moves
## the body, saves screenshots, and reports the player's position delta.

var world
var frame := 0
var start_pos := Vector3.ZERO


func _initialize() -> void:
	world = load("res://main.tscn").instantiate()
	root.add_child(world)


func _process(_delta: float) -> bool:
	frame += 1

	if frame == 30:
		start_pos = world.player.global_position
		var img := root.get_texture().get_image()
		img.save_png("user://shot_start.png")
		print("[cap] start pos: ", start_pos)

	# simulate holding W for ~40 physics frames by injecting the key event
	if frame >= 31 and frame <= 90:
		var ev := InputEventKey.new()
		ev.physical_keycode = KEY_W
		ev.pressed = true
		Input.parse_input_event(ev)

	if frame == 95:
		var moved: Vector3 = world.player.global_position - start_pos
		print("[cap] end pos:   ", world.player.global_position)
		print("[cap] moved by:  ", moved, "  (length ", moved.length(), ")")
		var img := root.get_texture().get_image()
		img.save_png("user://shot_after_move.png")

	if frame == 100:
		print("[cap] phase: ", world.phase, "  zombies: ", world.get_tree().get_nodes_in_group("zombie").size())
		quit(0)
		return true

	return false
