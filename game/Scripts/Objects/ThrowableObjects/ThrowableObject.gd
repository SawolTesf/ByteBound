extends RigidBody2D

var grabbed = false
var player = null
var hand_node = null
var in_range = false

func _ready():
	# Make sure Area2D exists
	if !has_node("Area2D"):
		push_error("ThrowableObject requires an Area2D child node!")
	else:
		$Area2D.monitoring = true
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
		$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _physics_process(delta: float):
	# Try to find player if we don't have a reference yet
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		if player and player.has_node("Hand"):
			hand_node = player.get_node("Hand")
	
	# When grabbed, move to hand position
	if grabbed and hand_node:
		global_position = hand_node.global_position
		# Disable physics while being held
		freeze = true

func _input(event):
	if InteractInput.is_just_pressed() and in_range:
		if !grabbed and player and player.canGrab:
			grab_object()
		elif grabbed:
			release_object(false)  # Just drop

	if ThrowInput.is_just_pressed() and grabbed:
		release_object(true)  # Throw

func _on_body_entered(body):
	Debug.debug(self, "Body entered: " + body.name, false)
	if body.is_in_group("Player"):
		in_range = true
		Debug.debug(self, "Player in range of throwable object", false)

func _on_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
		Debug.debug(self, "Player out of range of throwable object", false)

func grab_object():
	Debug.debug(self, "Grabbing object", false)
	grabbed = true
	player.canGrab = false
	
	# Disable gravity and collisions while held
	freeze = true

func release_object(should_throw):
	# Re-enable physics
	freeze = false
	
	# Apply appropriate force
	if should_throw:
		var throw_dir = Vector2.RIGHT if player.last_direction > 0 else Vector2.LEFT
		apply_central_impulse(throw_dir * Vector2(150, -200))
	else:
		var drop_dir = Vector2.RIGHT if player.last_direction > 0 else Vector2.LEFT
		apply_central_impulse(drop_dir * Vector2(20, 0))
		Debug.debug(self, "Releasing object (throw=%s)" % should_throw, false)
		grabbed = false
		player.canGrab = true
		freeze = false
