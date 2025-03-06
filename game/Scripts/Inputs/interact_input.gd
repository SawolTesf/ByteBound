class_name InteractInput extends Node

## Check if the interact action was just pressed
static func is_just_pressed() -> bool:
	return Input.is_action_just_pressed("interact")

## Check if the interact action is currently being held
static func is_pressed() -> bool:
	return Input.is_action_pressed("interact")

## Check if the interact action was just released
static func is_just_released() -> bool:
	return Input.is_action_just_released("interact")
