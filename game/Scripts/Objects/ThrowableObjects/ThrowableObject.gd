class_name Throwable extends CharacterBody2D


@export var throwable: throwables
@export var gravity : GravityComponent
@export var collision : CollisionShape2D

var hand_node : Node

var grabbed : bool = false 
var in_range : bool = false

func _ready():
	# makes sure the hit box node is set
	Validate.check_reference(self, "throwable", "Throwable")
	Validate.check_reference(self, "gravity", "GravityComponent")
	Validate.check_reference(self, "collision", "CollisionShape2D")
	
	throwable.init(self)
	gravity.init(self)


func _physics_process(delta: float) -> void:		
	gravity.physics_update(delta)
	move_and_slide()

	
func _process(delta: float) -> void:
	throwable.update(collision, gravity)

