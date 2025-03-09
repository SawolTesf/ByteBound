class_name Player extends CharacterBody2D

@export var state_controller: StateMachine
@export var sprite: AnimatedSprite2D
@export var input: InputComponent
@export var hand : Node
@export var camera : Camera2D
@export var movement_stats: MoveStats

var has_key: bool = false
var was_spoted : bool = false

# Control picking up object
var throwable_in_range : bool = false
var hands_free : bool = true

var dir : int # Constantly updated based on input

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
	Validate.check_reference(self, "hand", "Hand")
	
	# Initalize required nodes
	state_controller.init(self, sprite, movement_stats, input)
	hand.init(self)
	# Set up the signals
	SignalHub.key_collected.connect(_on_key_collected)
	
	# fov signals
	SignalHub.fov_entered.connect(_on_fov_entered)
	
	# hitbox signals
	SignalHub.hitbox_entered.connect(_on_hitbox_entered)
	SignalHub.hitbox_exited.connect(_on_hitbox_exited)

	
func _physics_process(delta: float) -> void:
	state_controller.process_physics(delta)
	sprite.flip_h = dir < 0

	#Uncomment to enable pushing ridged bodys
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D and c.get_collider().has_method("apply_central_impulse"):
			var push_force = (PUSH_FORCE * velocity.length() / movement_stats.get_speed(self)) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	

func _process(delta: float) -> void:
	# this is the dash timer
	dash_cooldown_check(delta)
	state_controller.process_frame(delta)

		

func _input(event : InputEvent) -> void:
	hand.update_direction(input)
	update_dir()


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

		if caller is Throwable:
			throwable_in_range = true
			caller.in_range = true
			Debug.debug(self, "Player Entered the hitbox of the throwable %s" % caller.in_range, false)
				

func _on_hitbox_exited(caller : Node2D, body : Node2D):
	if body == self:
		if caller is Throwable:
			caller.in_range = false
			throwable_in_range = false
			Debug.debug(self, "Player Exited the hitbox of the throwable %s" % caller.in_range, false)

# Timers ---------------------------------------------------------------------
func dash_cooldown_check(delta: float):
	if !movement_stats.is_dash_ready:
		movement_stats.dash_cooldown_timer -= delta
		if movement_stats.dash_cooldown_timer <= 0:
			movement_stats.is_dash_ready = true

# helpers
func update_dir():
	if input.get_left():
		dir = -1
	if input.get_right():
		dir = 1
