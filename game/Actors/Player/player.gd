class_name Player extends CharacterBody2D

## Allows you to assign refrences to the components in the inspector
@export_subgroup("Nodes")
@export var gravity: GravityComponent
@export var input: InputComponent
@export var animations: AnimationComponent
@export var jump: JumpComponent
@export var player_detection: Area2D
@export var player_move: MoveStats

var push_force: float = 50


# Track when the player should die then process it in _process
var is_detected: bool

### Built-Ins------------------------------------------------------------------
func _ready() -> void:
	player_detection.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	gravity.handle_gravity(self, delta)
	var direction = input.input_horizontal
	player_move.handle_horizontal_input(self, direction, delta)
	jump.handle_jumping(self, input.get_jump_input())
	animations.handle_move_animation(direction)
	animations.handle_jump_animation(jump.is_jumping, gravity.is_falling)
	## use move_and_slide over move_and_collide
	move_and_slide() # Always call when trying to update velocity

	for collision in get_slide_collision_count():
		var c = get_slide_collision(collision)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _process(_delta: float) -> void:
	if is_detected:
		get_tree().call_deferred("reload_current_scene")

### ---------------------------------------------------------------------------

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hazards"):
		get_tree.call_deferred("reload_current_scene")
