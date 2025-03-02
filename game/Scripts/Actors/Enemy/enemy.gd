class_name Enemy extends CharacterBody2D

@export_category("Components")
@export_subgroup("Internal")
@export var animations: AnimationComponent
@export var gravity: GravityComponent
@export var movement: MoveStats
@export var fov: FOV

@export_category("Timers")
@export_subgroup("Length")
@export var idle_duration: float = 2.0
@export var move_duration: float = 2.0

@export_category("Sight")
@export var num_segments: int = 10
@export var sight_distance: float = 100.0
@export var sight_angle: float = 45.0

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
	

func _physics_process(delta: float) -> void:
	fov.updateFOV()
	# Things that always need to be handled
	gravity.handle_gravity(self, false, delta)
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
