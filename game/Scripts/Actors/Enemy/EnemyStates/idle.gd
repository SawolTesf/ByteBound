extends State

var patrol : State
var idle : State
@export var idle_time : float = 4
var idle_timer : Timer
var can_idle: bool
var can_move : bool

func _ready() -> void:
	idle_timer = Timer.new()
	idle_timer.wait_time = idle_time
	idle_timer.one_shot = true
	add_child(idle_timer)
	idle_timer.timeout.connect(_idle_timer_timeout)

	if parent.has_method("can_idle"):
		print("parent contains can_idle variable")
		can_idle = parent.can_idle
	if parent.has_method("can_move"):
		print("parent contains can_move variable")
		can_move = parent.can_move

func enter():
	Debug.debug(self, "Enemy entered idle state")
	super()
	idle_timer.start() #upon enter start the timer when it times out you need to swap states

func exit():
	super()
	idle_timer.stop()

func _idle_timer_timeout():
	if move_stats.can_move:
		return patrol
	if !move_stats.can_move and move_stats.can_idle:
		return idle
