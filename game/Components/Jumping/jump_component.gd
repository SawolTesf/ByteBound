class_name JumpComponent extends Node
## Holds all the jump logic
##
## Implements a basic jump and some additional features such as: [br]
## 	 coyote jump [br]
## 	 Jump buffering [br]
##   Multi jump [br]

@export_subgroup("Settings")
## how high to jump, must be a negitive number
@export var jump_height: float = -350
## how much time to allow a player to jump after stepping of a ledge
@export var coyote_time: float = 0.5
## how long before hitting the ground a jump can be queued
@export var jumpbuffer_window: float = 0.5
@export_category("Jumping")
@export var can_multi_jump: bool
@export_subgroup("Multi Jump Settings")
## The max number of jumps a player is allowed
@export var max_jumps: int = 2
## The height of the multi jump, for the multi jump to be higher or lower than the normal
@export var multi_jump_height: float = -350

# booleans to help keep track of player movements
var is_jumping: bool = false
var is_jump_buffered: bool
var can_coyote_jump: bool
var jumps_used: int = 0

# Timers to allow for less strict jump conditions
var coyote_timer: Timer
var jump_buffer_timer: Timer

func _ready() -> void:
	_setup_coyote_timer()
	_setup_jumpbuffer_timer()

## Handles all the jumping logic [br]
## TODO: Maybe break the logic out in to other functions where applicable
func handle_jumping(body: CharacterBody2D, want_to_jump: bool):
	# Start the timers
	if want_to_jump:
		jump_buffer_timer.start()

	if body.is_on_floor():
		coyote_timer.start()
		jumps_used = 0
	
	# Determine their is time left on the timers
	can_coyote_jump = coyote_timer.time_left > 0
	is_jump_buffered = jump_buffer_timer.time_left > 0

	# This is the base jump logic consumes a charge of the jump just so the math works
	if (is_jump_buffered) and (body.is_on_floor() or can_coyote_jump):
		jumps_used += 1
		body.velocity.y = jump_height
		is_jumping = true
		coyote_timer.stop()
		_jump_buffer_timer_reset()
	
	# This is the multi jump logic
	if can_multi_jump:
		if !body.is_on_floor() and is_jump_buffered and jumps_used < max_jumps:
			body.velocity.y = multi_jump_height
			jumps_used += 1
			_jump_buffer_timer_reset()

	jump_buffer_timer.stop()
	is_jumping = body.velocity.y < 0 and not body.is_on_floor()


func _jump_buffer_timer_reset() -> void:
	jump_buffer_timer.stop()
	jump_buffer_timer.start()

func _setup_coyote_timer() -> void:
	coyote_timer = Timer.new()
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_time
	add_child(coyote_timer)

func _setup_jumpbuffer_timer() -> void:
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.wait_time = jumpbuffer_window
	add_child(jump_buffer_timer)
