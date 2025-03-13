extends Node2D

@export var mute: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	"""
	if not mute:
		play_music()
	"""
	pass
	
# Play BG Music
func play_music():
	if not mute:
		$Music.play()

# Play Laser Field
func play_lazer(isPlay):
	if isPlay:
		$LazerField.play()
	else:
		$LazerField.stop()

# Play Player Jump
func play_jump():
	if not mute:
		$PlayerJump.play()

# Play Key Collect
func play_key_collected():
	if not mute:
		$CardCollect.play()

# Play Button Interact
func play_button_pressed():
	if not mute:
		$ButtonInteract.play()

# Play Plate Stepped
func play_plate_stepped():
	if not mute:
		$PlateStepped.play()

# Play Enemy Detect
func play_enemy_detect():
	if not mute:
		$EnemyDetect.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
