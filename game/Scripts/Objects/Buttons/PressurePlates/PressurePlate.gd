class_name PressurePlate extends TriggerButton
## A pressure plate only deactivates a lazer while there is something on top of it.operator !=
##
## Checks for collisions with different types of objects.
## This allows for things like the player to turn off a lazer by standing on it or by placing a box on it.

#var plateStepped : AudioStreamPlayer2D

func _ready() -> void:
	super._ready()
	add_to_group("PressurePlates")

	# connect the signal
	body_exited.connect(_on_body_exited)

	#plateStepped = get_node("PlatePressed")


func _on_body_exited(body: Node2D) -> void:
	Debug.debug(self, "%s Left the area of the pressure plate" % body.get_script().get_global_name(), false)
	if body.is_in_group("Player"):
		# Play the transition animation (button being pressed)
		sprite.play("Deactivate")
		
		# set is active to flase before the signal is emitted
		# Makes sure that on leaving the deactivated signal is emitted 
		is_activated = false
		signal_emiter()

		
func signal_emiter() -> void:
	#plateStepped.play()
	AudioController.play_plate_stepped()

	if type != Globals.ButtonType.DEFAULT and is_activated:
		SignalHub.emit_pressure_plate_activated(type)
	
	if type != Globals.ButtonType.DEFAULT and !is_activated:
		SignalHub.emit_pressure_plate_deactivated(type)
