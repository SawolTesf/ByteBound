class_name MovableSquare extends CharacterBody2D

@export var acceleration : float = 5.0
@export var push_force : float = 5.0 # force applied to the box
@export var max_push_force: float = 15.0 # maximum force that can be applied to the box
@export var friction: float = 3.0 # allow the box to slide

# Refrences to the squares other nodes.
@export var gravity : GravityComponent # allow the block to fall
@export var collision : CollisionShape2D
@export var hitbox : Area2D
@export var hitbox_shape : CollisionShape2D

var push_box : bool = false # allows the box to be pushed
var direction : float


func _ready() -> void:
	# Set the box to the Movable group
	add_to_group("movable")

	# Make sure the node refrences exist.
	assert(gravity != null, "Squares GravityComponent is null")
	assert(collision != null, "Squares CollisionShape2D is null")
	assert(hitbox != null, "Squares Area2D is null")
	assert(hitbox_shape != null, "Squares Area2D CollisionShape2D is null")

	# Set up the signals to detect when the player is in contact with the box.
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	gravity.handle_gravity(self, false, delta) # always apply gravity to the box
	if push_box:
		# If the player is in contact with the box, apply a force to the box.
		velocity.x = lerp(velocity.x, direction * push_force, acceleration * delta)
	else:
		# If the player is not in contact with the box, apply friction to the box.
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	move_and_slide()


func _on_body_entered(body: Node) -> void:
	# If the player is in contact with the box, set the box to be pushed.
	if body is Player:
		print("DEBUG: Player is in contact with the box")

		direction = -sign(body.global_position.x - global_position.x) # should return -1 or 1
		print("DEBUG: direction is ", direction)
		
		push_box = true
		

func _on_body_exited(body: Node) -> void:
	# If the player is no longer in contact with the box, set the box to not be pushed.
	if body is Player:
		print("DEBUG: Player is no longer in contact with the box")
		push_box = false
