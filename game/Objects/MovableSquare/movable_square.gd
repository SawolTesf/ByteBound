class_name Movable extends RigidBody2D
### Allows the player to move an object by interacting with it.

@export var push_force: float

var is_pushing: bool
var is_pulling: bool

var player: Player = null

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if player: 
		print("player defiend apply force")
		var direction = (global_position - player.global_position).normalized()
		apply_force(-direction * push_force)

func start_interaction(player: CharacterBody2D) -> void:
	player = player

func stop_interaction() -> void:
	player = null
