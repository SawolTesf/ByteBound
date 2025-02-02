class_name MoveComponenet extends Node

@export_category("Movement Stats")
@export_subgroup("Movment type")
@export var advanced_movement: bool = false
@export var allow_dashing: bool = false ## if true, acceleration and decceleration will be used
@export_subgroup("Speed Stats")
@export var ground_speed: float = 100
@export var air_speed: float = 50
@export_subgroup("Acceleration Stats")
@export var ground_acceleration: float = 80
@export var air_acceleration: float = 20
@export_subgroup("Decceleration Stats")
@export var ground_decceleration: float = 50
@export var air_decceleratoin: float = 80
@export_subgroup("Dashed Stats")
@export var dash_speed: float = 200
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 3.0

var is_dashing: bool = false
var can_dash : bool
var dash_timer: Timer
var dash_cooldown_timer: Timer
var current_speed: float

enum MoveModes {WALK, DASH, CROUCH}

func _ready() -> void:
	if allow_dashing:
		_set_up_dash_timer()
		_set_up_dash_cooldown_timer()

func handle_horizontal_input(body: CharacterBody2D, direction: float, dashing: bool, delta: float) -> void:
	current_speed = get_speed(body, dashing)
	var a = get_acceleration(body)
	var d = get_decceleration(body)
	if dashing:
		dash()
	
	if direction != 0: # Player is moving
		if allow_dashing:
			dash_timer.start()
		if advanced_movement:
			body.velocity.x = move_toward(body.velocity.x, direction * current_speed, a * delta)
		else:
			body.velocity.x = direction * current_speed
	else: # Player is stoping
		if advanced_movement:
			body.velocity.x = move_toward(body.velocity.x, 0, d * delta)
		else:
			body.velocity.x = 0

# Getters --------------------------------------------------------------------------------------------------------
# used to determine which of the variables to use based on the state of the character
func get_speed(body: CharacterBody2D, dashing: bool) -> float:
	return ground_speed if body.is_on_floor() else air_speed

func get_acceleration(body: CharacterBody2D) -> float:
	return ground_acceleration if body.is_on_floor() else air_acceleration

func get_decceleration(body: CharacterBody2D) -> float:
	return ground_decceleration if body.is_on_floor() else air_decceleratoin

# Timers --------------------------------------------------------------------------------------------------------
func _set_up_dash_timer() -> void:
	dash_timer = Timer.new()
	dash_timer.wait_time = dash_duration
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_on_dash_timeout)
	add_child(dash_timer)

func _set_up_dash_cooldown_timer()->void:
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_on_dash_recharged)

func _on_dash_recharged():
	can_dash = true

func _on_dash_timeout():
	is_dashing = false
	current_speed = get_speed(get_parent(), false)

# helper function ------------------------------------------------------------
## Start the timer set the speed to dash_speed
func dash()-> void:
	is_dashing = true
	can_dash = false
	dash_timer.start()
	current_speed = dash_speed
	
