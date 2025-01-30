class_name EnemyPath extends PathFollow2D

@export var speed: float = 60
@export var idle_time: float = 2.0  # Changed to float (seconds)
const RIGHT_TARGET: float = 0.9
const LEFT_TARGET: float = 0.01

var idle_timer: Timer
var is_idle: bool = false
var direction: int = 1
var next_direction : int
var current_speed :float

func _ready() -> void:
	idle_timer = Timer.new()
	idle_timer.one_shot = true
	idle_timer.wait_time = idle_time
	idle_timer.timeout.connect(_idle_timeout)
	add_child(idle_timer)
	
	current_speed = speed

func move(delta: float) -> void:
	progress_ratio += direction * current_speed * delta / get_parent().curve.get_baked_length()
	if progress_ratio >= RIGHT_TARGET and not is_idle:
		next_direction = -1
		stop_and_idle()

	if progress_ratio <= LEFT_TARGET and not is_idle:
		next_direction = 1
		stop_and_idle()
		
func stop_and_idle() -> void:
	#print("entering idle")
	is_idle = true
	current_speed = 0
	direction = 0
	idle_timer.start()

func _idle_timeout() -> void:
	#print("Timer timedout")
	is_idle = false  
	current_speed = speed
	direction = next_direction
