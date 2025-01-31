class_name ExitDoor extends Area2D

signal door_entered

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		door_entered.emit()
		print("entering exit door")
