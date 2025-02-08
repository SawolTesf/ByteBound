class_name Interactable extends Area2D

signal plate_pressed

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		plate_pressed.emit()
		print("Pressure plate pressed")
