extends State

@export var patrol : State
@export var idle : State
var direction: int
var idle_timer : float = 0
var goto_idle : bool = false
var goto_patrol : bool = false
var swap_dir: bool = false

func enter():
	super()
	Debug.debug(self, "Enemy entered idle state")
	idle_timer = move_stats.idle_time
	parent.velocity = Vector2.ZERO
	parent.velocity.x = move_stats.starting_dir * -1


func process_frame(delta : float) -> State:
	update_timer(delta)
	if goto_idle:
		return idle
	if goto_patrol:
		return patrol
	return null

func process_physics(delta : float):
	parent.move_and_slide()

	
func exit():
	super()
	idle_timer = 0
	goto_idle = false
	goto_patrol = false

	
func update_timer(delta : float) -> void:
	idle_timer -= delta
	if idle_timer >= 0:
		return
	
	# if moving is not allowd go back to the idle state
	if !move_stats.can_move:
		move_stats.starting_dir *= -1
		swap_dir = true
		goto_idle = true
	# if moving is allowed go to the move state
	if move_stats.can_move:
		goto_patrol = true


	
