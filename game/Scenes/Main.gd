class_name GameNode extends Node2D

@export var list_of_levels: Array[PackedScene]

var exit_door: ExitDoor
var current_level: Node2D
var level: int = 0
var level00 = preload("res://Scenes/Levels/level_00.tscn")
var level01 = preload("res://Scenes/Levels/level_01.tscn")
var level02 = preload("res://Scenes/Levels/level_02.tscn")

func _ready() -> void:
	list_of_levels.append(level00)
	list_of_levels.append(level01)
	list_of_levels.append(level02)
	load_level(level)

func load_level(num: int):
	# Remove the current level if one exists
	if current_level:
		current_level.queue_free()
		await get_tree().process_frame # Wait for the node to be removed

	# Load and instance the new level
	current_level = list_of_levels[num].instantiate()
	add_child(current_level)
	# Ensure the scene tree updates
	await get_tree().process_frame

	exit_door = current_level.get_node_or_null("ExitDoor")
	if exit_door:
		exit_door.door_entered.connect(_on_exit_door_door_entered)
	else:
		print("Warning: ExitDoor not found in level ", num)


func _on_exit_door_door_entered() -> void:
	print("Door Entered")
	level += 1
	if level < list_of_levels.size():
		load_level(level)
	else:
		print("You have completed the game!")
