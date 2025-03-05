class_name Key extends Area2D

var collectSound : AudioStreamPlayer2D

func _ready() -> void:
	add_to_group("Key")
	body_entered.connect(_on_body_entered)
	collectSound = get_node("CardCollected")
	
## When the player body enters the keys area
## Set has_key to be true emit a signal 
## remove the key from the queue
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SignalHub.emit_key_collected()
		collectSound.play()
		print("Key collected!")
		queue_free()
