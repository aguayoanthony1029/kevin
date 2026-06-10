extends SceneTree
## Inspection render: places one of each zombie breed at a fixed distance, frozen
## in a mid-stride pose, and screenshots in day and night so we can judge the
## models, animation pose, materials, and atmosphere cleanly.

var world
var frame := 0
var zombies := []


func _initialize() -> void:
	world = load("res://main.tscn").instantiate()
	root.add_child(world)


func _pose_zombies() -> void:
	var ZombieScript = load("res://scripts/zombie.gd")
	var breeds := ["walker", "runner", "brute"]
	for i in 3:
		var z = ZombieScript.new()
		z.setup(breeds[i])
		z.world = world
		z.position = Vector3(-2.5 + i * 2.5, 0.0, -4.0)
		world.add_child(z)
		zombies.append(z)


func _freeze_and_pose() -> void:
	for z in zombies:
		z.set_physics_process(false)        # stop them chasing; anims keep playing
		z.look_at(Vector3(z.global_position.x, 0, 100), Vector3.UP)  # face the camera
	# tilt the view down a touch to frame the figures
	world.player.camera.rotation.x = -0.12
	world.hide_start_prompt()


func _process(_delta: float) -> bool:
	frame += 1

	if frame == 15:
		_pose_zombies()
	if frame == 25:
		_freeze_and_pose()

	if frame == 35:
		root.get_texture().get_image().save_png("user://shot_day.png")
		print("[cap] day shot saved")
		world.phase = world.Phase.NIGHT
		world.night_number = 2

	if frame == 140:
		_freeze_and_pose()  # re-apply pose (physics-off zombies don't move)
		root.get_texture().get_image().save_png("user://shot_night.png")
		print("[cap] night shot saved")
		quit(0)
		return true

	return false
