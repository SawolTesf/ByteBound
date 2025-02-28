class_name Lazer extends Area2D

var sprite : AnimatedSprite2D
var is_active : bool = true
var perma_open: bool = false
var type : Globals.LazerType = Globals.LazerType.DEFAULT

# set true when the player leaves pressure plate, set false one the Active animation is playing
var just_activated : bool = false 

func _ready() -> void:
	sprite = get_node("AnimatedSprite2D")
	assert(sprite != null, "DEBUG Lazer/_ready(): The sprite is null")
	sprite.play("Active") # Start the lazers off as active
	
	# Set up the signals to detect player collision and animations
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	# if the laser was just activated and there is no animation playing, play active
	if !sprite.is_playing() and just_activated:
		sprite.play("Active")
		just_activated = false

func _on_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		if is_active:
			print("DEBUG Lazer/_on_body_entered(): The player hit the active lazer rest the stage")
			SceneManager.reload_current_level()
		else:
			print("DEBUG Lazer/_on_body_entered(): The player hit the inactive lazer, Allow them to pass through")


func _on_body_exited(body : Node) -> void:
	if body.is_in_group("Player"):
		print("TODO Lazer/_on_body_exited(): The player has left the lazer, Why? What should happen?")
