class_name Enemy extends CharacterBody2D

@export_category("Components")
@export_subgroup("Internal")
@export var animations: AnimationComponent
@export var gravity: GravityComponent
@export var movement: MoveStats
@export var fov : FoV
@export_subgroup("External")
@export var player: Player

@export_category("Timers")
@export_subgroup("Length")
@export var idle_duration: float = 2.0
@export var move_duration: float = 2.0

@export_category("Sight")
@export var num_segments: int
@export var sight_distance: float
@export var sight_angle: float

@export_category("Actions")
@export var starting_direction: int = 1
@export var can_move: bool
@export var can_idle: bool

# Chase feature
@export_category("Chase")
@export var chase_duration: float = 5.0
@export var chase_modulate_color: Color = Color(1, 0, 0, 0.6)
var chase_timer: Timer
var is_chasing: bool = false
var chase_target: Node2D
var _original_fov_modulate: Color

var ray_params: PhysicsRayQueryParameters2D
var player_in_range: bool
var player_in_sight: bool

var move_timer: Timer
var idle_timer: Timer
var is_idle: bool
var direction: float
var patrol_origin: Vector2
var is_returning: bool = false
@export var return_threshold: float = 4.0
var hitbox: Area2D

# Built-Ins -----------------------------------------------------------------
func _ready() -> void:
	direction = starting_direction
	setup_idle_timer()
	setup_move_timer()
	if can_move or (can_idle and can_move):
		move_timer.start()
	elif can_idle and not can_move:
		idle_timer.start()

	fov.init(self, num_segments, sight_angle, sight_distance)
	gravity.init(self)
	# setup chase timer
	setup_chase_timer()
	# cache original FoV color for alert tint
	_original_fov_modulate = fov.modulate
	# record patrol start position
	patrol_origin = global_position
	# safely get HitBox node and connect if present
	hitbox = get_node_or_null("HitBox")
	if hitbox:
		hitbox.body_entered.connect(_on_HitBox_body_entered)


func _physics_process(delta: float) -> void:
	fov.update(direction)
	gravity.physics_update(delta)
	animations.handle_move_animation(direction)

	if is_returning:
		# Return-to-patrol override
		var dx_ret = patrol_origin.x - global_position.x
		if abs(dx_ret) > return_threshold:
			direction = sign(dx_ret)
			movement.handle_horizontal_input(self, direction, delta)
			var prev_x = global_position.x
			move_and_slide()
			if is_on_floor() and abs(global_position.x - prev_x) < 1.0:
				movement.handle_jump(self)
				move_and_slide()
			# detect contact during return
			for i in range(get_slide_collision_count()):
				var col = get_slide_collision(i).get_collider()
				if col is Player:
					col.handleDeath()
		else:
			# arrived back, resume patrol
			is_returning = false
			direction = starting_direction
			if can_move or (can_idle and can_move): move_timer.start()
			elif can_idle: idle_timer.start()
		return
	elif is_chasing and chase_target:
		# Chase override with jump
		var dx = chase_target.global_position.x - global_position.x
		direction = sign(dx) if dx != 0 else direction
		var dy = chase_target.global_position.y - global_position.y
		if dy < -10 and is_on_floor():
			movement.handle_jump(self)
		movement.handle_horizontal_input(self, direction, delta)
		move_and_slide()
		# detect contact and end chase
		for i in range(get_slide_collision_count()):
			var col = get_slide_collision(i).get_collider()
			if col is Player:
				col.handleDeath()
		return
	# Patrol/idle behavior
	if can_move:
		if not (is_idle and can_idle):
			movement.handle_horizontal_input(self, direction, delta)
	move_and_slide()
	# detect contact during patrol
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i).get_collider()
		if col is Player:
			col.handleDeath()

# Timers -------------------------------------------------------------------
func setup_move_timer() -> void:
	move_timer = Timer.new()
	move_timer.one_shot = true
	move_timer.wait_time = move_duration
	move_timer.timeout.connect(_on_move_timeout)
	add_child(move_timer)

func setup_idle_timer() -> void:
	idle_timer = Timer.new()
	idle_timer.one_shot = true
	idle_timer.wait_time = idle_duration
	idle_timer.timeout.connect(_on_idle_timeout)
	add_child(idle_timer)

## This signial should only be called if move is enabled
## if both move and idle are enabled, then go to idle when called
## if only move is eabled then flip directions and restart the timer
func _on_move_timeout() -> void:
	#print("Move Timer Ended")
	if can_idle and can_move:
		#print("move and idle are enabled")
		is_idle = true
		idle_timer.start()
	elif can_move and not can_idle:
		direction = -direction
		move_timer.start()
	
## This function should only ever go off if idle is enabled.
## If both move and idle are enabled, Start moving when this is called
## if only idle is enabled restart the timer
## regardless of options the direction will switch if this signal is called
func _on_idle_timeout() -> void:
	#print("Idle Timer Ended")
	direction = -direction
	# if only idle is enabled
	if not can_move and can_idle:
		#print("only idle is enabled restart the timer")
		idle_timer.start() # restart the timer
	# if both move and idle are enabled
	if can_idle and can_move:
		#print("idle and move enabled start moving again")
		is_idle = false # we want to move
		move_timer.start() # we just finished idleing start moving

# Chase timer setup and handlers
func setup_chase_timer() -> void:
	chase_timer = Timer.new()
	chase_timer.one_shot = true
	chase_timer.wait_time = chase_duration
	chase_timer.timeout.connect(_on_chase_timeout)
	add_child(chase_timer)

func start_chase(target: Node2D) -> void:
	chase_target = target
	is_chasing = true
	# tint FoV to alert color
	fov.modulate = chase_modulate_color
	chase_timer.start()

func _on_chase_timeout() -> void:
	is_chasing = false
	chase_target = null
	# restore FoV tint
	fov.modulate = _original_fov_modulate
	# begin return to patrol
	is_returning = true

func _on_HitBox_body_entered(body: Node) -> void:
	if body is Player:
		body.handleDeath()
