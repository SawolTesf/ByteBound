class_name Player extends CharacterBody2D

var state_controller: StateMachine
var sprite: AnimatedSprite2D
var input: InputComponent
@export var camera : Camera2D
@export var movement_stats: MoveStats
var has_key: bool = false 

var last_direction : int = 1

const PUSH_FORCE: float = 15.0
const MIN_PUSH_FORCE: float = 1.0

# Builtins --------------------------------------------------------------------
func _ready() -> void:
	# Make sure the player is in the player group
	if !self.is_in_group("Player"):
		self.add_to_group("Player")
		
	# Set up the sprite
	sprite = get_node("PlayerSprite")
	
	# Set up the input	
	input = get_node("InputComponent")
	
	# Set up the state machine
	state_controller = get_node("StateMachine")
	state_controller.init(self, sprite, input, movement_stats)
	
	# Set up the signals
	SignalHub.key_collected.connect(_on_key_collected)
	SignalHub.player_detected.connect(_on_player_detected)

	
func _physics_process(delta: float) -> void:
	state_controller.process_physics(delta)

	if velocity.x != 0:
		last_direction = sign(velocity.x)
	sprite.flip_h = last_direction < 0
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D and c.get_collider().has_method("apply_central_impulse"):
			var push_force = (PUSH_FORCE * velocity.length() / movement_stats.get_speed(self)) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	

func _process(delta: float) -> void:
	# this is the dash timer
	dash_cooldown_check(delta)

	state_controller.process_frame(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_controller.process_input(event)

# Signals --------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hazards"): #for some reason hazards are not being detected?
		Debug.debug(self, "Player Collided with %s, from the hazards group" % body, false)
		get_tree().call_deferred("reload_current_scene")

func _on_key_collected() -> void:
	has_key = true
	Debug.debug(self, "Player Collected a Key\nHas Key: %s" % has_key, false)


func _on_player_detected() -> void:
	Debug.debug(self, "Player Was Spotted by the enemy", false)
	SceneManager.reload_current_level()
	
# Timers ---------------------------------------------------------------------
func dash_cooldown_check(delta: float):
	if !movement_stats.is_dash_ready:
		movement_stats.dash_cooldown_timer -= delta
		if movement_stats.dash_cooldown_timer <= 0:
			movement_stats.is_dash_ready = true
