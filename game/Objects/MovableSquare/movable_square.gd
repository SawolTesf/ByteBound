class_name Movable extends RigidBody2D
## Allows movable objects to look for collisions with the player
##
## Uses signals to manage what happens when different objects collide with a moveable object

func _ready() -> void:
	add_to_group("Movable")
	contact_monitor = true
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	print("Collision detected with: ", body.name)

func _on_body_exited(body: Node) -> void:
	print("Collision ended with: ", body.name)