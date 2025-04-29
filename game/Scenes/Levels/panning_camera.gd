extends Camera2D

var init_activated: bool = false
@onready var lazer = $"../Node/BlueLazer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.blue_pedistal_activated.connect(_pan_camera)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pan_camera():
	if !init_activated:	
		init_activated = true
		position = lazer.position
		print(position)
