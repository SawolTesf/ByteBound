class_name Hitbox extends Area2D
## A class that adds an area 2D for checks to its parent
##
## This Script will set up the shape of the colliion shape
## Connect Signals for on bodyentered and on bodyexited

@export_category("CollisionShape")
@export var collision_shape : CollisionShape2D
var parent : PhysicsBody2D
@export_subgroup("shape")
@export_enum("Circle", "Rectangle", "Capsule") var shape_type : int = 1
@export var x : float = 10
@export var y : float  = 10

@export_subgroup("Color")
@export var color : Color


func _ready() -> void:
	parent = get_parent()
	setUpCollisionShape()

	
func createShape():
	match(shape_type):
		0:
			return CircleShape2D.new()
		1:
			return RectangleShape2D.new()
		2:
			return CapsuleShape2D.new()
		_:
			Debug.debug("No Shape was defined useing the default RectangleShape2D", false)
			Debug.log("No Shape was defined useing the default RectangleShape2D", false)
			return RectangleShape2D.new()


## Used to initalize the collision shape and set the shape, size and color
func setUpCollisionShape() -> void:
	if not collision_shape:
		collision_shape = find_child("CollisionShape2D")
	var shape = createShape()
	shape.size = Vector2(x, y)
	collision_shape.shape = shape
	
	
