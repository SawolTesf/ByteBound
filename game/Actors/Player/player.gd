class_name Player extends CharacterBody2D

var state_controller: StateMachine
var sprite: AnimatedSprite2D
var input: InputComponent
@export var movement_stats: MoveStats
var has_key: bool = false 
var is_detected: bool

var interacting_object: Movable = null
@export var interaction_range: float = 32.0


# Builtins --------------------------------------------------------------------
func _ready() -> void:
	state_controller = get_node("StateMachine")
	sprite = get_node("PlayerSprite")
	input = get_node("InputComponent")
	state_controller.init(self, sprite, input, movement_stats)

func _physics_process(delta: float) -> void:
	state_controller.process_physics(delta)
	
	if Input.is_action_just_pressed("interact"):
		print("interact pressed")
		if interacting_object:
			interacting_object.stop_interaction()
			interacting_object = null
		else:
			detect_and_interact()


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

# DOES NOTWORK
# need to find an implementatino that will allow the player to know when to interact with a rigidbody
func detect_and_interact():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_bodies = true
	var results = space_state.intersect_point(query, 1)
	print(results)
	for result in results:
		var body = result["collider"]
		print(body)
		if body is Movable:
			interacting_object = body
			body.start_interaction(self)
			break
