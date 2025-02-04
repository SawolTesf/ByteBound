class_name ExitDoor extends Area2D

signal door_entered

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_key:
			door_entered.emit()
			print("entering exit door with the key")
		else:
			print("DEBUG: Player needs a key to open this door.")