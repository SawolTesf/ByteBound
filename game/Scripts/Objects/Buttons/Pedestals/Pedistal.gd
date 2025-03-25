class_name Pedestal extends TriggerButton
## This is the base class for all pedistals.
##
## Each pedistal will need a refrence to its animated sprite to change its animation.
## Each pedistal will emit a signal based on the type of pedistal it is.
## For this we use a enum to define the type of the pedistal. (Set this for each subclass)
## The pedistal will emit a signal when the player enters the area. (call signal_emiter() in the subclass)

#var buttonPressed : AudioStreamPlayer2D

func _ready() -> void:
	super._ready()
	# Add the pedistal to the "Pedistals" group
	add_to_group("Pedistals")

	#buttonPressed = get_node("ButtonClicked")


## Emits a signal based on the type of pedestals
func signal_emiter() -> void:
	AudioController.play_sound("ButtonInteract")
	if type != Globals.ButtonType.DEFAULT:
		SignalHub.emit_pedistal_activated(type)
