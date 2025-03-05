extends Node
## Global Component to manage signals
##
## Used to allow multiple nodes to react to a single event.
## Helps to decouple nodes. Instead of a node needing refrences to other nodes,
## it can just emit a signal and any node that is listening will react to it.

#------------------------------------------------------------------------------------------------
# Emit this signal when the key is collected
signal key_collected
func emit_key_collected():
	key_collected.emit()

#------------------------------------------------------------------------------------------------
# Emit this signal when a player collides with a hazard.
signal hazard_enterd
func emit_hazard_entered():
	hazard_enterd.emit()

#------------------------------------------------------------------------------------------------
# Emit this signal when a player is detected.
signal player_detected
func emit_player_detected():
	player_detected.emit()

#------------------------------------------------------------------------------------------------
# Handle the Pedistal activation
signal red_pedistal_activated
signal green_pedistal_activated
signal blue_pedistal_activated
func emit_pedistal_activated(type : Globals.ButtonType):
	match type:
		Globals.ButtonType.RED:
			red_pedistal_activated.emit()
		Globals.ButtonType.GREEN:
			green_pedistal_activated.emit()
		Globals.ButtonType.BLUE:
			blue_pedistal_activated.emit()
		Globals.ButtonType.DEFAULT:
			print("DEBUG: The pedistal type was not set.")

#------------------------------------------------------------------------------------------------
# Handle the Pressure plate activation
signal red_pressure_plate_activated
signal green_pressure_plate_activated
signal blue_pressure_plate_activated
func emit_pressure_plate_activated(type : Globals.ButtonType):
	match type:
		Globals.ButtonType.RED:
			red_pressure_plate_activated.emit()
		Globals.ButtonType.GREEN:
			green_pressure_plate_activated.emit()
		Globals.ButtonType.BLUE:
			blue_pressure_plate_activated.emit()
		Globals.ButtonType.DEFAULT:
			print("DEBUG: The pressure plate type was not set.")

#handle the Pressure plate deactivation
signal red_pressure_plate_deactivated
signal green_pressure_plate_deactivated
signal blue_pressure_plate_deactivated
func emit_pressure_plate_deactivated(type : Globals.ButtonType):
	match type:
		Globals.ButtonType.RED:
			red_pressure_plate_deactivated.emit()
		Globals.ButtonType.GREEN:
			green_pressure_plate_deactivated.emit()
		Globals.ButtonType.BLUE:
			blue_pressure_plate_deactivated.emit()
		Globals.ButtonType.DEFAULT:
			print("DEBUG: The pressure plate type was not set.")

#------------------------------------------------------------------------------------------------
