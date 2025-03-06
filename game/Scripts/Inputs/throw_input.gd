class_name ThrowInput extends Node

## Check if the throw action was just pressed
static func is_just_pressed() -> bool:
	return Input.is_action_just_pressed("throw")

## Check if the throw action is currently being held
static func is_pressed() -> bool:
	return Input.is_action_pressed("throw")

## Check if the throw action was just released
static func is_just_released() -> bool:
	return Input.is_action_just_released("throw")
