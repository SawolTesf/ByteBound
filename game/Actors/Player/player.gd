class_name Player extends CharacterBody2D

var state_controller: StateMachine
var sprite: AnimatedSprite2D
var input: InputComponent
@export var movement_stats: MoveStats
var has_key: bool = false 
var is_detected: bool

const PUSH_FORCE: float = 15.0
const MIN_PUSH_FORCE: float = 10.0

# Builtins --------------------------------------------------------------------
func _ready() -> void:
	state_controller = get_node("StateMachine")
	sprite = get_node("PlayerSprite")
	input = get_node("InputComponent")
	state_controller.init(self, sprite, input, movement_stats)

func _physics_process(delta: float) -> void:
	state_controller.process_physics(delta)
	
	# Collide with rigidbodys
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / movement_stats.get_speed(self)) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	

func _process(delta: float) -> void:
	# this is the dash timer
	dash_cooldown_check(delta)
	# player has been spoted
	if is_detected:
		get_tree().call_deferred("reload_current_scene")
	state_controller.process_frame(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_controller.process_input(event)

# Signals --------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hazards"):
		print("DEBUG: Player collided with a hazard. Reloading scene.")
		get_tree().call_deferred("reload_current_scene")

# Timers ---------------------------------------------------------------------
func dash_cooldown_check(delta: float):
	if !movement_stats.is_dash_ready:
		movement_stats.dash_cooldown_timer -= delta
		if movement_stats.dash_cooldown_timer <= 0:
			movement_stats.is_dash_ready = true
