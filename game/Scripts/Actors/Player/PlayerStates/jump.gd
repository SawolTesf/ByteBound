extends State
## JUMP STATE
##
## The jump state can only enter 2 states itself for multi jumping and falling

@export_category("Transitions")
@export var fall_state: State
@export var jump_state: State
@export var dash_state: State


func enter() -> void:
	super.enter()
	print("DEBUG/JUMP: Player Entered the Jump State ", move_stats.jumps_used)
	# Immediatly make the player jump.
	move_stats.handle_jump(parent)
	parent.move_and_slide()
		
	# Every jump used should count against the max amount of jumps
	print(move_stats.jumps_used)

func process_input(_event: InputEvent) -> State:
	# IF MULTI JUMP IS ALLOWED
	if move_stats.multi_jump:
		if move_stats.max_jumps > move_stats.jumps_used:
			if get_jump_input():
				return jump_state
	
	# Allow dashes while jumping
	if check_dash_conditions():
		return dash_state
	return

func process_physics(delta: float) -> State:
	# HANDLE MOVING THE PLAYER AROUND
	move_stats.handle_gravity(parent, get_fastfall_input(), delta)
	move_stats.handle_horizontal_input(parent, input.input_horizontal, delta)
	parent.move_and_slide()

	# CHECK FOR STATE CHANGES
	if parent.velocity.y > 0:
		return fall_state
	return null
