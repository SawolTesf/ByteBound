class_name InputComponent extends Node
## Handles Player Input 
##
## This componet should only be added to game objects te player wants to control
## Constanly pools for left and right input every frame and assigns it to [member InputComponent.input_horizontal]

## either -1.0, 0.0, 1.0
var input_horizontal : float = 0.0

# checks every frame if input was given
func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("ui_left", "ui_right")

## Checks to see if the player wants to jump.
## This is useful when combining the jump and input components.
## Call this function as on of the parameters of [method JumpComponent.handle_jump]
func get_jump_input() -> bool:
	return Input.is_action_just_pressed("ui_accept")
