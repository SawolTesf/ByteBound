class_name LevelTemplate extends Node2D
	
var bgMusic : AudioStreamPlayer2D

func _ready() -> void:
	bgMusic = get_node("BackgroundMusic")
  get_tree().paused = false
	#bgMusic.play()
