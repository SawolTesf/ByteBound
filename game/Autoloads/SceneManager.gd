extends Node

# List of the levels in the game
var level_00 : String = "res://Scenes/Levels/level_00.tscn"
var level_01 : String = "res://Scenes/Levels/level_01.tscn"
var level_03 : String = "res://Scenes/Levels/level_03.tscn"
var level_04 : String = "res://Scenes/Levels/level_04.tscn"

# array to hold all the level paths
var level_paths : Array[String] = [level_00, level_01, level_03, level_04]

var current_level_path: int = 0 # Start on the first level.
var current_level = null

func _ready() -> void:
	var root = get_tree().root
	current_level = root.get_child(-1)


func load_level(level) -> void:
	_defered_load_level.call_deferred(level)


func _defered_load_level(level) -> void:
	# It is now safe to remove the current scene.
	current_level.free()

	# Load the new scene.
	var s = ResourceLoader.load(level)

	# Instance the new scene.
	current_level = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_level)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_level
	
	
func reload_current_level() -> void:
	load_level(level_paths[current_level_path])


func next_level() -> void:
	current_level_path += 1
	load_level(level_paths[current_level_path])


func previous_level() -> void:
	current_level_path -= 1
	load_level(level_paths[current_level_path])
