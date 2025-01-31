class_name MoveStats extends Resource

@export_category("Movement Stats")
@export_subgroup("Movment type")
@export var advanced_movement: bool = false ## if true, acceleration and decceleration will be used
@export_subgroup("Speed Stats")
@export var ground_speed: float = 100
@export var air_speed: float = 50
@export_subgroup("Acceleration Stats")
@export var ground_acceleration: float = 80
@export var air_acceleration: float = 20
@export_subgroup("Decceleration Stats")
@export var ground_decceleration: float = 50
@export var air_decceleratoin: float = 80
@export_subgroup("Weight Stats")
@export var mass: float = 20

func handle_horizontal_input(body: CharacterBody2D, direction: float, delta: float) -> void:
	var s = get_speed(body)
	var a = get_acceleration(body)
	var d = get_decceleration(body)

	if direction != 0: # Player is moving
		if advanced_movement:
			body.velocity.x = move_toward(body.velocity.x, direction * s, a * delta)
		else:
			body.velocity.x = direction * s
	else: # Player is stoping
		if advanced_movement:
			body.velocity.x = move_toward(body.velocity.x, 0, d * delta)
		else:
			body.velocity.x = 0

# Getters --------------------------------------------------------------------------------------------------------
# used to determine which of the variables to use based on the state of the character
func get_speed(body: CharacterBody2D) -> float:
	return ground_speed if body.is_on_floor() else air_speed

func get_acceleration(body: CharacterBody2D) -> float:
	return ground_acceleration if body.is_on_floor() else air_acceleration

func get_decceleration(body: CharacterBody2D) -> float:
	return ground_decceleration if body.is_on_floor() else air_decceleratoin
