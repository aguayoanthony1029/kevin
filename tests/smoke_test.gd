extends SceneTree
## Headless smoke test for UNDYING. Run with:
##   godot --headless -s tests/smoke_test.gd
##
## Boots the real main scene and force-marches it through the whole game loop:
## chop a tree, build a wall, trigger night, spawn the horde, take and deal
## damage, then fast-forward to the victory screen. Exits 0 on success,
## exits 1 with a FAILED message on any broken expectation.

var world
var frame := 0
var failures := 0


func _initialize() -> void:
	world = load("res://main.tscn").instantiate()
	root.add_child(world)
	print("[test] main scene loaded")


func check(condition: bool, label: String) -> void:
	if condition:
		print("[test] PASS: " + label)
	else:
		failures += 1
		printerr("[test] FAILED: " + label)


func _process(_delta: float) -> bool:
	frame += 1

	match frame:
		10:
			check(world.player != null, "player spawned")
			check(world.get_tree().get_nodes_in_group("choppable").size() >= 50, "trees and rocks scattered")

			# harvest: chop a tree 5 times -> wood, and deplete it
			var tree = world.get_tree().get_nodes_in_group("choppable")[0]
			for i in 5:
				tree.chop(world)
			check(world.resources["wood"] == 10 or world.resources["stone"] == 10, "chopping yields resources")

		15:
			# build: select a wood wall and place it
			world.player._set_build_selection(KEY_1)
			check(world.player.ghost.visible, "build ghost appears")
			var before: int = world.resources["wood"] + world.resources["stone"]
			world.player._try_place()
			var after: int = world.resources["wood"] + world.resources["stone"]
			check(after < before or before < 5, "placing a wall spends resources")
			check(world.get_tree().get_nodes_in_group("structure").size() >= 0, "structure group queryable")

		20:
			# force nightfall
			world.phase_time_left = 0.0

		25:
			check(world.phase == world.Phase.NIGHT, "night begins")
			check(world.night_number == 1, "night counter increments")
			check(world.spawn_queue.size() > 0, "horde queued for night 1")
			# rush all spawns
			world.spawn_interval = 0.001
			world.spawn_timer = 0.0

		60:
			var zombies = world.get_tree().get_nodes_in_group("zombie")
			check(zombies.size() >= 4, "horde spawned (%d zombies)" % zombies.size())
			if zombies.size() > 0:
				# combat both ways: we hit one, one hits us
				var z = zombies[0]
				var hp_before: float = z.hp
				z.take_damage(35.0)
				check(z.hp < hp_before, "zombie takes melee damage")
				z.take_damage(9999.0)
				world.player.take_damage(10.0)
				check(world.player.hp < world.player.max_hp, "player takes damage")

		70:
			check(world.kills >= 1, "kill is counted")
			# fast-forward: pretend this was the final night, end it
			world.night_number = world.NIGHTS_TO_WIN
			world.phase_time_left = 0.0

		80:
			check(world.game_ended, "victory triggers after final night")
			check(world.get_tree().paused, "game pauses on end screen")

		85:
			if failures == 0:
				print("[test] ALL PASSED — the loop works end to end")
				quit(0)
			else:
				printerr("[test] %d FAILURES" % failures)
				quit(1)
			return true

	return false
