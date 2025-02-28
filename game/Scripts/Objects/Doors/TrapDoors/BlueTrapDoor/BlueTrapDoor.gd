class_name BlueTrapDoor extends StaticBody2D
## A trap door can be used to block off an area or objects, and only open when the proper button is hit.
## 
## Similar to a laser but the trap door has a physical collision due to its static body.
## The trap door should open when the appropriate color intractable is pressed.
## Only cares about the signals that are emitted when its corresponding button is pressed.

var sprite : AnimatedSprite2D # Used to change the animations
var collision : CollisionShape2D # Used to disable the collision when the door is opened

func _ready() -> void:
	# Setup the sprite
	sprite = get_node("AnimatedSprite2D")
	assert(sprite != null, "ERROR/BlueTrapDoor: AnimatedSprite2D not set")
	sprite.play("Idle") # Always start the door in a idle animation
	sprite.animation_finished.connect(_on_animation_finished)

	#Set up the collision object
	collision = get_node("CollisionShape2D")
	assert(collision != null, "ERROR/BlueTrapDoor: CollisionShape2D not set")

	# setup the signalhub
	SignalHub.blue_pressure_plate_activated.connect(_on_blue_pressure_plate_activated)
	SignalHub.blue_pressure_plate_deactivated.connect(_on_blue_pressure_plate_deactivated)

	
## when the pressure plate is activated open the doors
## once the open animation is done we need to disable the collision
func _on_blue_pressure_plate_activated() -> void:
	sprite.play("Open")
	sprite.animation_finished.emit()

	
## when the pressure plate is deactivated close the doors
## TODO: decide if the collision comes back before the animation or after?
func _on_blue_pressure_plate_deactivated() -> void:
	sprite.play("Shut")
	sprite.animation_finished.emit()

	
## Used to change the collision of the door after the animation plays
func _on_animation_finished() -> void:
	if sprite.animation == "Open":
		collision.set_deferred("disabled", true)
	if sprite.animation == "Shut":
		collision.set_deferred("disabled", false)
