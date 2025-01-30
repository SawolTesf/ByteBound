class_name AnimationComponent extends Node

@export_category("Nodes")
@export  var sprite : AnimatedSprite2D

func handle_horizontal_flip(move_direction : float):
	if move_direction == 0:
		return
	
	sprite.flip_h = false if move_direction > 0 else true

func handle_move_animation(move_direction : float) -> void:
	handle_horizontal_flip(move_direction)
	
	if move_direction != 0:
		sprite.play("Move")
	else:
		sprite.play("Idle")
		
func handle_jump_animation(is_jumping : bool, is_falling : bool):
	if is_jumping:
		sprite.play("Jump")
	if is_falling:
		sprite.play("Fall")

func play_death_animation() -> void:
	sprite.play("Death")
