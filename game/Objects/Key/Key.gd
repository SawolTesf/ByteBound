extends Area2D

signal key_collected

func _ready() -> void:
	add_to_group("Key")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.has_key = true
		emit_signal("key_collected")
		print("Key collected!")
		queue_free()
