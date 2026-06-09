extends Node3D
## Builds UNDYING's first playable world entirely in code, so the project runs the
## moment you open it — no manual scene setup required.
##
## What it makes: sunlight + sky, a big grassy ground, some solid "trees" (cylinders),
## a little on-screen control hint, and the player. It's deliberately crude — this is
## the skeleton we'll grow into the real game, one milestone at a time.

func _ready() -> void:
	_setup_environment()
	_setup_ground()
	_spawn_trees()
	_setup_hud()
	_spawn_player()


func _setup_environment() -> void:
	# The sun (a directional light), angled like late afternoon.
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	sun.light_energy = 1.2
	sun.shadow_enabled = true
	add_child(sun)

	# A procedural sky + soft ambient light so nothing is pitch black.
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	sky.sky_material = ProceduralSkyMaterial.new()
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.4

	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)


func _setup_ground() -> void:
	var ground := StaticBody3D.new()

	# Visible grassy plane.
	var mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(80, 80)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.4, 0.2)
	plane.material = mat
	mesh.mesh = plane
	ground.add_child(mesh)

	# Matching collision so we don't fall through it.
	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(80, 0.2, 80)
	col.shape = box
	col.position = Vector3(0, -0.1, 0)
	ground.add_child(col)

	add_child(ground)


func _spawn_trees() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in 25:
		var tree := StaticBody3D.new()

		var mesh := MeshInstance3D.new()
		var trunk := CylinderMesh.new()
		trunk.top_radius = 0.3
		trunk.bottom_radius = 0.4
		trunk.height = 3.0
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.35, 0.25, 0.15)
		trunk.material = mat
		mesh.mesh = trunk
		tree.add_child(mesh)

		var col := CollisionShape3D.new()
		var shape := CylinderShape3D.new()
		shape.radius = 0.4
		shape.height = 3.0
		col.shape = shape
		tree.add_child(col)

		# Scatter trees, but keep a clear patch around the spawn point.
		var x := rng.randf_range(-35, 35)
		var z := rng.randf_range(-35, 35)
		if Vector2(x, z).length() < 5.0:
			x += 8.0
		tree.position = Vector3(x, 1.5, z)
		add_child(tree)


func _setup_hud() -> void:
	var layer := CanvasLayer.new()
	var label := Label.new()
	label.text = "UNDYING — first steps\nWASD: move   Mouse: look   Shift: sprint   Space: jump   Esc: free mouse"
	label.position = Vector2(16, 16)
	layer.add_child(label)
	add_child(layer)


func _spawn_player() -> void:
	var player_scene := preload("res://player.tscn")
	var player := player_scene.instantiate()
	player.position = Vector3(0, 2, 0)  # start slightly above ground and drop in
	add_child(player)
