extends State

var idle : State
var patrol : State
var can_idle: bool
var can_move: bool
var patrol_timer : Timer
@export var patrol_time : float = 4

func _ready() -> void:
	patrol_timer = Timer.new()
	patrol_timer.wait_time = patrol_time
	patrol_timer.one_shot = true
	add_child(patrol_timer)
	patrol_timer.timeout.connect(_patrol_timer_timeout)
	if parent.has_method("can_idle"):
		print("parent contains can_idle variable")
		can_idle = parent.can_idle
	if parent.has_method("can_move"):
		print("parent contains can_move variable")
		can_move = parent.can_move

func enter():
	super()
	Debug.debug(self, "Enemy entered the Patrol State")
	patrol_timer.start()

func exit():
	super()
	patrol_timer.stop()

func _patrol_timer_timeout():
	# if you cant idle keep moving
	if !move_stats.can_idle:
		return patrol
	# if you can idle enter the idle state.
	if move_stats.can_idle:
		return idle
