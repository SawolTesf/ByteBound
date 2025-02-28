class_name GameOverlay extends CanvasLayer

@onready var current_time: Label = %CurrentTime
var run_timer : Timer
var elpased_time: int

func _ready() -> void:
	setup_timer()

func setup_timer()-> void:
	run_timer = Timer.new()
	run_timer.wait_time = 1.0
	add_child(run_timer)
	run_timer.timeout.connect(_on_timer_timeout)
	run_timer.start()
	
func _on_timer_timeout() -> void:
	elpased_time += 1
	current_time.text = format_time(elpased_time)
	
func format_time(seconds : int) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	var millis = int((seconds - int(seconds)) * 100)
	return "%02d:%02d.%02d" % [minutes, secs, millis]
