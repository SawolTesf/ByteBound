class_name Enemy extends CharacterBody2D

@export_category("Components")
@export_subgroup("Internal")
@export var animations: AnimationComponent
@export var gravity: GravityComponent
@export var movement: MoveStats
@export var fov : FoV
@export_subgroup("External")
@export var player: Player

@export_category("Timers")
@export_subgroup("Length")
@export var idle_duration: float = 2.0
@export var move_duration: float = 2.0

@export_category("Sight")
@export var num_segments: int
@export var sight_distance: float
@export var sight_angle: float

@export_category("Actions")
@export var starting_direction: int = 1
@export var can_move: bool
@export var can_idle: bool

var ray_params: PhysicsRayQueryParameters2D
var player_in_range: bool
var player_in_sight: bool

var move_timer: Timer
var idle_timer: Timer
var is_idle: bool
var direction: float




# Built-Ins -----------------------------------------------------------------
func _ready() -> void:
	direction = starting_direction
	setup_idle_timer()
	setup_move_timer()
	if can_move or (can_idle and can_move):
		move_timer.start()
	elif can_idle and not can_move:
		idle_timer.start()

	fov.init(self, num_segments, sight_angle, sight_distance)
	gravity.init(self)
	

func _physics_process(delta: float) -> void:
	# Run fov and sight check
	fov.update(direction)
	# Things that always need to be handled
	gravity.physics_update(delta)
	animations.handle_move_animation(direction)
	
	if (can_move and can_idle) or can_move:
		if is_idle and can_idle:
			return
		else:
			movement.handle_horizontal_input(self, direction, delta)
	
	move_and_slide()
	

# Timers -------------------------------------------------------------------
func setup_move_timer() -> void:
	move_timer = Timer.new()
	move_timer.one_shot = true
	move_timer.wait_time = move_duration
	move_timer.timeout.connect(_on_move_timeout)
	add_child(move_timer)

func setup_idle_timer() -> void:
	idle_timer = Timer.new()
	idle_timer.one_shot = true
	idle_timer.wait_time = idle_duration
	idle_timer.timeout.connect(_on_idle_timeout)
	add_child(idle_timer)

## This signial should only be called if move is enabled
## if both move and idle are enabled, then go to idle when called
## if only move is eabled then flip directions and restart the timer
func _on_move_timeout() -> void:
	#print("Move Timer Ended")
	if can_idle and can_move:
		#print("move and idle are enabled")
		is_idle = true
		idle_timer.start()
	elif can_move and not can_idle:
		direction = -direction
		move_timer.start()
	
## This function should only ever go off if idle is enabled.
## If both move and idle are enabled, Start moving when this is called
## if only idle is enabled restart the timer
## regardless of options the direction will switch if this signal is called
func _on_idle_timeout() -> void:
	#print("Idle Timer Ended")
	direction = -direction
	# if only idle is enabled
	if not can_move and can_idle:
		#print("only idle is enabled restart the timer")
		idle_timer.start() # restart the timer
	# if both move and idle are enabled
	if can_idle and can_move:
		#print("idle and move enabled start moving again")
		is_idle = false # we want to move
		move_timer.start() # we just finished idleing start moving
	


### State Implementation
# @export_category("Components")
# @export var fov : FoV
# @export var sprite : AnimatedSprite2D
# @export var state_machine : StateMachine
# @export var move_stats : MoveStats

# @export_category("FoV variables")
# @export var fov_segments : int = 20
# @export var fov_distance : float = 100.0
# @export var fov_angle : float = 45.0

# var ray_params: PhysicsRayQueryParameters2D
# var player_in_range: bool = false 
# var player_in_sight: bool = false


# # Built-Ins -----------------------------------------------------------------
# func _ready() -> void:
# 	# Make sure the refrences were set.
# 	Validate.check_reference(self, "fov", "FoV")
# 	Validate.check_reference(self, "sprite", "EnemySprite")
# 	Validate.check_reference(self, "state_machine", "StateMachine")

# 	assert(fov != null , "ERROR: no fov")
# 	assert(sprite != null, "ERROR: no sprite")
# 	assert(state_machine != null, "ERROR: No State Machine")

# 	# Initalize the components
# 	fov.init(self, fov_segments, fov_angle, fov_distance)
# 	state_machine.init(self, sprite, move_stats)

# func _unhandled_input(event: InputEvent) -> void:
# 	state_machine.process_input(event)
		
# func _process(delta: float) -> void:
# 	state_machine.process_frame(delta)
	
# func _physics_process(delta: float) -> void:
# 	state_machine.process_physics(delta)
# 	fov.update()
