extends Node2D

@export var mute: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_sound("Music")


# Get the node for the sound and play it
func play_sound(sound):
	var sound_node = get_node(sound)
	if not sound_node:
		return

	sound_node.play()

# Get the node for the sound and stop it
func stop_sound(sound):
	var sound_node = get_node(sound)
	if not sound_node:
		return

	sound_node.stop()

"""
# Play BG Music
func play_music():
	$Music.play()

# Play Laser Field
func play_lazer():
	$LazerField.play()

# Play Player Jump
func play_jump():
	$PlayerJump.play()

# Play Key Collect
func play_key_collected():
	$CardCollect.play()

# Play Button Interact
func play_button_pressed():
	$ButtonInteract.play()

# Play Plate Stepped
func play_plate_stepped():
	$PlateStepped.play()

# Play Enemy Detect
func play_enemy_detect():
	$EnemyDetect.play()
"""