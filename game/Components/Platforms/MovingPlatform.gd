extends PathFollow2D

@export var speed = 100
var target : float = .99

func _physics_process(delta: float) -> void:
	move_back_and_forth(delta)

func move_back_and_forth(delta : float) -> void:
	if progress_ratio >  target:
		target = .01
		progress -= speed * delta
	elif progress_ratio < target:
		target = .99
		progress += speed * delta
	
	
