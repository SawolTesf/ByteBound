class_name Enemy extends CharacterBody2D

@export_category("Components")
@export var fov : FoV
@export var sprite : AnimatedSprite2D
@export var state_machine : StateMachine
@export var move_stats : MoveStats

@export_category("FoV variables")
@export var fov_segments : int = 20
@export var fov_distance : float = 100.0
@export var fov_angle : float = 45.0

@export_category("Move Options")
@export var can_move: bool = false
@export var can_idle: bool = true

var ray_params: PhysicsRayQueryParameters2D
var player_in_range: bool = false 
var player_in_sight: bool = false



# Built-Ins -----------------------------------------------------------------
func _ready() -> void:
	# Make sure the refrences were set.
	Validate.check_reference(self, "fov", "FoV")
	Validate.check_reference(self, "sprite", "EnemySprite")
	Validate.check_reference(self, "state_machine", "StateMachine")

	assert(fov != null , "ERROR: no fov")
	assert(sprite != null, "ERROR: no sprite")
	assert(state_machine != null, "ERROR: No State Machine")

	# Initalize the components
	fov.init(self, fov_segments, fov_angle, fov_distance)
	state_machine.init(self, sprite, move_stats)

	
		

func _process(delta: float) -> void:
	fov.update()
