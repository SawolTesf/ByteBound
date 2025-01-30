class_name Enemy extends CharacterBody2D

@export_category("Components")
@export var animations : AnimationComponent
@export var movement : MovementComponent
@export var gravity : GravityComponent
## TODO: Implement the Path2D 

var speed : float = 100
var idle_time: float = 40
var idle_timer: float = 0
var target : float = 0.99


func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	gravity.handle_gravity(self, delta)
	animations.handle_move_animation(1)
	
	move_and_slide() # More advanced then move_and_collide
