class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity: GravityComponent
@export var input: InputComponent
@export var movement: MovementComponent
@export var animations : AnimationComponent
@export var jump: JumpComponent

var is_dead : bool

func _physics_process(delta: float) -> void:
	gravity.handle_gravity(self, delta)
	var direction = input.input_horizontal
	movement.handle_horizontal_input(self, direction)
	jump.handle_jumping(self, input.get_jump_input())
	animations.handle_move_animation(direction)
	animations.handle_jump_animation(jump.is_jumping, gravity.is_falling)
	
	move_and_slide()

func _process(delta: float) -> void:
	# Handles the death of the player
	if is_dead:
		animations.play_death_animation()
		await get_tree().create_timer(3).timeout
		get_tree().call_deferred("reload_current_scene")

# Player has collided with a hazard in the tile set
# play death animation and reload scene
func _on_player_hazard_entered(body: Node2D) -> void:
	is_dead = true
