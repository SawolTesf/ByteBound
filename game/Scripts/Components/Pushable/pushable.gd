class_name Pushable extends Node2D

@export_category("Forces")
@export_subgroup("push Forces")
@export var min_push_force : float
@export var push_force : float
@export var max_push_force : float

@export_subgroup("move Forces")
@export var acceleration : float
@export var friction : float

var parent : PhysicsBody2D
func _ready() -> void:
	parent = get_parent()
	
	
