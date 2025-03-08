class_name Key extends CharacterBody2D

var grav_comp : GravityComponent
var hitbox : Hitbox

func _ready() -> void:
	grav_comp = get_node("GravityComponent")
	assert(grav_comp != null, "ERROR/Key: GravityComponent not set")

	hitbox = find_child("HitBox")
	assert(hitbox != null, "ERROR/Key: Area2D not set")
	hitbox.init(self)
	
	SignalHub.key_collected.connect(_on_key_collected)

func _physics_process(delta : float) -> void:	
	grav_comp.handle_gravity(self, false, delta)
	move_and_slide()


## What Happens when this object is collected?
func _on_key_collected() -> void:
	self.queue_free()
