class_name Hitbox extends Area2D
## A class that adds an area 2D for checks to its parent
##
## This Script will set up the shape of the colliion shape
## Connect Signals for on bodyentered and on bodyexited

@export_category("CollisionShape")
@export var collision_shape : CollisionShape2D
var parent : PhysicsBody2D
@export_subgroup("shape")
@export_enum("Circle", "Rectangle", "Capsule") var shape_type : int
@export var x : float = 10
@export var y : float  = 10

@export_subgroup("Color")
@export var color : Color


func _ready() -> void:
	parent = get_parent()
	setUpCollisionShape()

func createShape():
	match(shape_type):
		"Circle":
			return CircleShape2D.new()
		"Rectangle":
			return RectangleShape2D.new()
		"Capsule":
			return CapsuleShape2D.new()
		_:
			print("WARNING: no valid shape was given defaulting to Rect")
			return RectangleShape2D.new()
	
## Used to initalize the collision shape and set the shape, size and color
func setUpCollisionShape() -> void:
	if not collision_shape:
		collision_shape = find_child("CollisionShape2D")
	var shape = createShape()
	shape.size = Vector2(x, y)
	collision_shape.shape = shape
	
	

