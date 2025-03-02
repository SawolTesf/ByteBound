extends State
## This is the enemys Idle State
##
## The enemy should stand still untill another state is swapped to.

@export_category("States")
@export var patrol : State
@export var chase : State

# Determins how long the enemy will stay in the idle state
var idle_timer : Timer
@export var idle_time : float 

func _ready() -> void:
	# Set up the timer only once
	idle_timer.wait_time = idle_time
	add_child(idle_timer)

## When entering the idle State
## Set the enemy velocity to zero
## Start the idle timer
func enter() -> void:
	super()
	print("DEBUG/IDLE: Enemy Entered the Idle State")
	parent.velocity = Vector2.ZERO
	idle_timer.start()

func exit() -> void:
	idle_timer.stop()
	super()

## When the idle Timer runs out if the enemy can move go to the move state
func _idle_timeout() -> State:
	if parent.can_move:
		return patrol
	return null
