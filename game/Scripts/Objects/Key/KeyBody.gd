class_name Key extends CharacterBody2D

var grav_comp : GravityComponent
var hitbox : Hitbox

func _ready() -> void:
	grav_comp = get_node("GravityComponent")
	assert(grav_comp != null, "ERROR/Key: GravityComponent not set")

	hitbox = find_child("HitBox")
	assert(hitbox != null, "ERROR/Key: Area2D not set")
	hitbox.body_entered.connect(_on_body_entered)

	
func _physics_process(delta : float) -> void:	
	grav_comp.handle_gravity(self, false, delta)
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SignalHub.emit_key_collected()
		print("Key collected!")
		queue_free()
