### AS OF NOW DOES NOT WORK I DONOT THINK THIS IS A GOOD IDEA
### WHEN I WOULD ADD NODES TO THE FOLLOWPATH2D IT WOULD CHANGE THE BASE SCENE TOO

### The PatrolPath class is used to allow an actor or object
### to move along a specified path.
## Should be generic enough to beable to give to both actors and objects
## Such as both patroling enemies and moving platforms
## In the current implementation:
##	- All paths will go from point to point.
##	- At each point the odject will stop and idle to 
class_name PatrolPath extends Path2D

### ---------------------------------------------------------------------------
## These settings should be assigned to the PathFollow2D upon creation
@export_category("Pathfollow2D settings")
@export var loops : bool
@export var rotates : bool
@export var cubic_interp : bool
## These settings determine how an object moves along the path
@export_category("Movement Settings")
@export var speed : float = 40
@export var idle_time : float = 2
@export var allow_idle : bool # used to turn on and off idle
@export var allow_chase : bool # used to turn on and off chases

## Refrences
var follow_path : PathFollow2D
var idle_timer : Timer
@export var object : CharacterBody2D
## Bools to determine State:
var is_idle : bool
var is_chaseing : bool
## Holds the points along the path
var points: PackedVector2Array = []
var point_index : int = 0
var target_point : Vector2
## additional Movement
var direction : Vector2 = Vector2.ZERO
 
### ---------------------------------------------------------------------------
### Built in functions 
func _ready() -> void:
	setup_follow_path()
	setup_idle_timer()
	points = curve.get_baked_points()
	object = get_node("CharacterBody2D")
	follow_path.add_child(object)

func _process(delta: float) -> void:
	move_logic(delta)

func _physics_process(delta: float) -> void:
	pass

### ---------------------------------------------------------------------------
### Helper Functions

## Make Sure this is called in the ready
## passes user settings to the PathFollow2D
func setup_follow_path() -> void:
	# make sure the path settings are set correctly
	follow_path = get_node("PathFollow2D")
	follow_path.cubic_interp = cubic_interp
	follow_path.rotates = rotates
	follow_path.loop = loops

func setup_idle_timer() -> void:
	idle_timer = Timer.new()
	idle_timer.one_shot = true
	idle_timer.wait_time = idle_time
	idle_timer.timeout.connect(_idle_over)
	add_child(idle_timer)
	
func get_number_of_points() -> int:
	return curve.point_count

### ---------------------------------------------------------------------------
### Movement Functions
# TODO: Implement the different movment actions that can be taken.

## This funciton determines what actions should be taken
func move_logic(delta : float) -> void:
	## End of the line turn around
	if point_index >= points.size():
		return # TODO: Move object back to start along the points
	
	## If Idle is enabled
	if allow_idle:
		if is_idle: # make sure we are not allready idle
			point_index += 1
			stop_and_idle()
		else: # else we were just idle move normaly
			move(delta)
	## Idle not enabled move Directly through points
	else:
		is_idle = false
		move(delta)

func stop_and_idle() -> void:
	is_idle = true
	idle_timer.start()
	
func move(delta : float) -> void:
	target_point = curve.get_point_position(point_index)
	direction = (target_point - follow_path.global_position).normalized()
	var distance = follow_path.global_position.distance_to(target_point)

	# Move the object along the direction
	if distance > speed * delta:
		follow_path.global_position += direction * speed * delta
	else:
		# Snap to the point and move to the next one
		follow_path.global_position = target_point
		point_index += 1
		move_logic(delta)  # Re-evaluate movement logic

func chase_target() -> void:
	pass

func _idle_over():
	is_idle = false
