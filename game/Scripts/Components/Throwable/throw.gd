class_name throwables extends Node2D

@export_category("Behavior")
@export var can_throw : bool = true # if we allow a throw or just pick up and drop

@export_category("Nodes")
@export var hitbox : Hitbox # hit box to use for input detection
@export var input : InputComponent

@export_category("Throw Settings")
@export var throw_force : float
@export var throw_angle : float

var is_picked_up : bool = false
var parent : Node2D

# Call this in the parents _ready() function
func init(p : CharacterBody2D) -> void:
	self.parent = p # set the refrence to its parent node (node that will be picked up)
	# validate the required nodes
	Validate.check_reference(self, "hitbox", "HitBox")
	Validate.check_reference(self, "input", "InputComponent")
	hitbox.init(self)

	
# used to check if the object is picked up if it is suspend the gravity and collision
func update(collision : CollisionShape2D, gravity : GravityComponent) -> void:
	if is_picked_up:
		if collision:
			collision.disabled = true
		if gravity:
			gravity.paused = true
	elif !is_picked_up:
		if collision:
			collision.disabled = false
		if gravity:
			gravity.paused = false
	
	
# If the player is in range of the throwable_hitbox
# and the player wants to pick it up we need to do the following
# take the object and make it a child of the parents hand.
func pickup(player : Player) -> void:
	var message : String = "Calling the throwable Pickup Function\nChecking states\nPlayer Has hands? %s\nPlayer Hands Free? %s"
	var params : Array = [player.hand, player.hands_free]
	Debug.debug(self, message % params)
	if player.hands_free and player.hand:
		parent.call_deferred("reparent", player.hand)
		is_picked_up = true
		player.hands_free = false
		Debug.debug(self, "Player should have picked up the object\nis_picked_up: %s\nplayer.hands_free %s" % [is_picked_up, player.hands_free])
		

func drop(player : Player) -> void:
	Debug.debug(self, "Calling the throwable Drop Function")
	if !player.hands_free and player.get_parent():
		parent.call_deferred("reparent", player.get_parent())
		await get_tree().process_frame
		player.hands_free = true
		is_picked_up = false


func throw() -> void:
	Debug.debug(self, "Calling the throwable throw Function")
	pass
