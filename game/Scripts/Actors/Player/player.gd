class_name Player extends CharacterBody2D

@export var state_controller: StateMachine
@export var sprite: AnimatedSprite2D
@export var input: InputComponent
@export var hand : Node
@export var camera : Camera2D
@export var movement_stats: MoveStats
var throwable: throwables

var has_key: bool = false
var was_spoted : bool = false

# Control picking up object
var throwable_in_range : bool = false
var hands_free : bool = true

var last_direction : int = 1

const PUSH_FORCE: float = 15.0
const MIN_PUSH_FORCE: float = 1.0

# Builtins --------------------------------------------------------------------
func _ready() -> void:
	# Make sure the player is in the player group
	if !self.is_in_group("Player"):
		self.add_to_group("Player")
		
	# Set up the nodes
	Validate.check_reference(self, "sprite", "PlayerSprite")
	Validate.check_reference(self, "input", "InputComponent")
	Validate.check_reference(self, "state_controller", "StateMachine")
	
	# Initalize required nodes
	state_controller.init(self, sprite, movement_stats, input)
	
	# Set up the signals
	SignalHub.key_collected.connect(_on_key_collected)
	
	# fov signals
	SignalHub.fov_entered.connect(_on_fov_entered)
	
	# hitbox signals
	SignalHub.hitbox_entered.connect(_on_hitbox_entered)
	SignalHub.hitbox_exited.connect(_on_hitbox_exited)

	
func _physics_process(delta: float) -> void:
	state_controller.process_physics(delta)

	if velocity.x != 0:
		last_direction = sign(velocity.x)
	sprite.flip_h = last_direction < 0

	## Uncomment to enable pushing ridged bodys
	# for i in get_slide_collision_count():
	# 	var c = get_slide_collision(i)
	# 	if c.get_collider() is RigidBody2D and c.get_collider().has_method("apply_central_impulse"):
	# 		var push_force = (PUSH_FORCE * velocity.length() / movement_stats.get_speed(self)) + MIN_PUSH_FORCE
	# 		c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	

func _process(delta: float) -> void:
	# this is the dash timer
	dash_cooldown_check(delta)
	state_controller.process_frame(delta)


func _input(event : InputEvent) -> void:
	if input.get_interact() and throwable and throwable_in_range:
		if !throwable.is_picked_up:
			throwable.pickup(self)
		elif throwable.is_picked_up:
			throwable.drop(self)


func _unhandled_input(event: InputEvent) -> void:
	state_controller.process_input(event)

		
	
# Signals --------------------------------------------------------------------
func _on_key_collected() -> void:
	has_key = true
	Debug.debug(self, "Player Collected a Key\nHas Key: %s" % has_key, false)


func _on_fov_entered(caller : Node2D, body : Node2D) -> void:
	if self == body:
		if caller is Enemy:
			Debug.debug(self, "Player Was Spotted by the enemy", false)
			SceneManager.reload()

			


		
## Determine which hitbox the player hit
func _on_hitbox_entered(caller : Node2D, body : Node2D) -> void:
	if body == self:
		Debug.debug(self, "Player received hitbox signal from %s" % caller.name, false)
		if caller is Key:
			Debug.debug(self, "Player Entered the hitbox of the key", false)
			has_key = true
			SignalHub.key_collected.emit()
		
		if caller is throwables:
			throwable_in_range = true # flag the player as in range
			throwable = caller # set the refrence to the throwables component parent
			var params = [self.name, throwable,  throwable_in_range, hands_free]
			Debug.debug(self, "Player entered the hit box of a throwable object\n%s in range of %s? %s\nPlayers hands are free? %s" % params)
				

func _on_hitbox_exited(caller : Node2D, body : Node2D):
	if body == self:
		if caller is throwables:
			throwable_in_range = false
			var params = [self.name, throwable,  throwable_in_range]
			Debug.debug(self, "Player exited the hit box of a throwable object\n%s in range of %s? %s" % params)

# Timers ---------------------------------------------------------------------
func dash_cooldown_check(delta: float):
	if !movement_stats.is_dash_ready:
		movement_stats.dash_cooldown_timer -= delta
		if movement_stats.dash_cooldown_timer <= 0:
			movement_stats.is_dash_ready = true
