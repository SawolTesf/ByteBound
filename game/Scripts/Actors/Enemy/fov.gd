class_name FOV extends Area2D
## calculates and draws the fov of the character
##
## Uses RayCast2D to gather points in space to draw the fov collision polygon with.
## Increase the num_of_segments to make the polygon smoother on surfaces

var points: Array[Vector2] = [Vector2.ZERO] # hold points that make up the polygon
@export var fov_collision: CollisionPolygon2D
@export var fov_display: Polygon2D

var num_of_segments: int = 5
var sight_angle: float
var sight_distance: float
var parent: Enemy

func _ready() -> void:
	parent = get_parent()
	assert(parent != null, "Parent not found")
	assert(parent.get_class() == "CharacterBody2D", "Parent is not of type CharacterBody2D")
	
	sight_angle = parent.sight_angle
	sight_distance = parent.sight_distance
	num_of_segments = parent.num_segments
	body_entered.connect(_on_fov_entered)


# Handle RayCasting ---------------------------------------------------------------------------------------------------
## Create a PhysicsRayQueryParameters2D object to cast a ray from the origin to the target
## Pass this into intersect_ray() to get the first object it hits
func create_ray_params(origin: Vector2, target: Vector2) -> PhysicsRayQueryParameters2D:
	var params = PhysicsRayQueryParameters2D.new()
	params.from = origin
	params.to = target
	params.collision_mask = collision_mask
	params.exclude = [self]
	params.collide_with_bodies = true
	params.collide_with_areas = false
	return params

## Updates the points Array with the points to use in the polygon
func calcRayPoint() -> void:
	var half_angle = deg_to_rad(sight_angle) / 2.0
	var angle_step = (2.0 * half_angle) / float(num_of_segments)

	var facing = Vector2(parent.direction, 0)
	# Start from -half_angle and go to +half_angle
	for i in range(num_of_segments + 1):
		var angle = - half_angle + (angle_step * i)
		
		# Rotate the ray by the entity's facing direction plus the current angle
		var direction = facing.rotated(angle)
		
		# Calculate the endpoint
		var endpoint = direction * sight_distance
		points.append(endpoint)
	

## Takes the points array and cast a ray starting at the body ending on each point in the array
## Checks in the ray hits an object. If it does make the point of contact the new point in the polygon
func castRays() -> void:
	var space_state = get_world_2d().direct_space_state
	for i in range(points.size()):
		var global_target = to_global(points[i])
		var params = create_ray_params(self.global_position, global_target)
		var result = space_state.intersect_ray(params)
		if result:
			points[i] = to_local(result.position)

			
func drawFOV() -> void:
	# Create a properly formed polygon with the origin at the center
	var final_points = PackedVector2Array()
	final_points.append(Vector2.ZERO) # Start with the origin
	
	# Add all other points in order
	for i in range(1, points.size()):
		final_points.append(points[i])
	
	if fov_collision:
		fov_collision.polygon = final_points
	if fov_display:
		fov_display.polygon = final_points

# Used to draw gizmos to debug the arrays
# func _draw() -> void:
# 	# Draw rays
# 	for point in points:
# 		draw_line(Vector2.ZERO, point, Color(1, 0, 0), 2.0)
	
# 	# Draw the FOV polygon outline (optional)
# 	if points.size() > 1:
# 		draw_polyline(points, Color(0, 1, 0), 2.0, true)

func updateFOV() -> void:
	points.clear()
	calcRayPoint()
	castRays()
	drawFOV()
	queue_redraw() # Redraw the gizmos



#Signals -------------------------------------------------------------------------------------------------
func _on_fov_entered(body: Node2D) -> void:
	print("DEBUG/FOV: body: ", body, " entered FoV")
	if body.is_in_group("Player"):
		SignalHub.player_detected.emit()

