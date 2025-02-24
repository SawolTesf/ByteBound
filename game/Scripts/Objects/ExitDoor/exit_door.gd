class_name ExitDoor extends Area2D

var _door_sprite : AnimatedSprite2D
var _door_locked : bool = true
var _door_open : bool = false

func _ready() -> void:
	# Set up the signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	SignalHub.key_collected.connect(_on_key_collected)
	
	# Set up the default sprite
	_door_sprite = get_node("DoorSprite")
	assert(_door_sprite != null, "DoorSprite not found")
	_door_sprite.play("Locked")


## Called when the player collects a key, Chnage door state to unlocked
func _on_key_collected() -> void:
	print("Debug: Key Collected, Door is now unlocked.")
	_door_sprite.play("Unlocked")
	_door_locked = false


func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("Player"):
		# Check the state of the door
		if _door_locked == false:
			print("Debug: Player Entered Door, and Door is unlocked.")
			_door_open = true
			_door_sprite.play("Open")
		else:
			print("Debug: Player Entered Door, but Door is locked.")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player Left Door area")
		if _door_open == true:
			_door_open = false	
			_door_sprite.play("Close")

