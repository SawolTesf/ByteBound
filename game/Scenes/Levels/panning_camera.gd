extends Camera2D

var init_activated: bool = false
@onready var player_cam = $"../Characters/Player".camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.blue_pedistal_activated.connect(_pan_camera)

func _pan_camera():
	if !init_activated:	
		init_activated = true
		if player_cam.is_current():
			make_current()
		else:
			player_cam.make_current()

		
