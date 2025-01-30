class_name JumpComponent extends Node

@export_subgroup("Settings")
@export var jump_height : float = -350
@export var coyote_time : float = 0.5
@export var jumpbuffer_window : float = 0.5

var is_jumping : bool = false
var is_jump_buffered : bool
var can_coyote_jump : bool
# Timers to allow for less strict jump conditions
var coyote_timer : Timer
var jump_buffer_timer : Timer

func _ready() -> void:
	setup_coyote_timer()
	setup_jumpbuffer_timer()

func handle_jumping(body : CharacterBody2D, want_to_jump : bool):
	# Start the timers
	if want_to_jump:
		jump_buffer_timer.start()
	if body.is_on_floor():
		coyote_timer.start()
	
	# Determine their is time left on the timers
	can_coyote_jump = coyote_timer.time_left > 0
	is_jump_buffered = jump_buffer_timer.time_left > 0
	if (is_jump_buffered) and (body.is_on_floor() or can_coyote_jump):
		body.velocity.y = jump_height
		is_jumping = true
		coyote_timer.stop()
		jump_buffer_timer.stop()
	
	is_jumping = body.velocity.y < 0 and not body.is_on_floor()


func setup_coyote_timer() -> void:
	coyote_timer = Timer.new()
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_time
	add_child(coyote_timer)


func setup_jumpbuffer_timer() -> void:
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.wait_time = jumpbuffer_window
	add_child(jump_buffer_timer)
