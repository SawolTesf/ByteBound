extends State

@export var idle : State
@export var patrol : State
var direction : float = 1
var patrol_timer : float = 0
var goto_idle : bool = false
var goto_patrol : bool = false

func enter():
	super()
	patrol_timer = move_stats.move_time
	Debug.debug(self, "Enemy entered the Patrol State")
	

func process_physics(delta: float):
	move_stats.handle_gravity(parent, false, delta)
	if parent:
		move_stats.handle_horizontal_input(parent, direction, delta)
	parent.move_and_slide()

	
func process_frame(delta : float) -> State:
	update_timer(delta)

	if goto_idle:
		return idle
	if goto_patrol:
		return patrol
	return null

	
func exit():
	super()
	patrol_timer = 0
	goto_idle = false
	goto_patrol = false


func update_timer(delta : float) -> void:
	patrol_timer -= delta
	if patrol_timer >= 0:
		return
	
	direction = -direction
	# if moving is not allowd go back to the idle state
	if move_stats.can_idle:
		goto_idle = true
	# if moving is allowed go to the move state
	if !move_stats.can_idle:
		goto_patrol = true


	
