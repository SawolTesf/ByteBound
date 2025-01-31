class_name GravityComponent extends Node
## This component applies gravity to a [PhysicsBody2D]
##
## This component should be added as a child node of any [PhysicsBody2D]
## The component modifies velocity.y and determine if the body is falling
## TODO: Can be extended to allow for different types of gravitys:
##		- Low gravity ()
##		- Air gravity (changes how floaty a character is)

@export_subgroup("Settings")
## The amount of force to be applied to the body.velocity.y 
## This value should be positive
@export var gravity: float = 1000.0

## Will be true if the body is not on the floor 
## and the body.velocity.y is positive
var is_falling: bool

## If the player is not on the floor apply a downward force.
## This is only applied if they are not on the floor 
## keeping the velocity.y from causing isues if the actor jumps
func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
		
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
