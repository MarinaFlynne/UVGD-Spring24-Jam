extends Node2D

@export var line: Line2D
@export var ray: RayCast2D
var laser_start_direction = Vector2.LEFT
var bounces = 0;
const MAX_RAY_DIST = 1000
const MAX_BOUNCES = 100
const RAY_MULTIPLIER_H = 1.01

signal new_laser_req(starting_pt, direction)

func process_mirror_collision(coll, pt) -> bool:
	#process_mirror_collision(ray,prev,coll,pt)
	var normal = ray.get_collision_normal()
	
	# If the normal is ever zero, break. This can happen if we start out inside a mirror hitbox
	if normal == Vector2.ZERO:
		return false
	
	# new raycast
	ray.global_position = pt
	ray.global_position *= 1.01
	ray.target_position = ray.target_position.bounce(normal)
	
	ray.force_raycast_update()
	
	return true
	
func process_splitter_collision(coll, pt, ray):
	new_laser_req.emit(coll.new_laser_point.global_position, Vector2.DOWN)
	
	var ray_direction = (pt - ray.global_position).normalized()
	var ray_start_y = pt.y
	var ray_start = Vector2(coll.laser_through_point.global_position.x, ray_start_y)

	new_laser_req.emit(ray_start, ray_direction)
	
	pass

func process_laser():
	#first line point is at 0,0
		line.clear_points()
		line.add_point(Vector2.ZERO)
		
		# initialize ray
		ray.global_position = line.global_position
		# cast the ray
		ray.target_position = laser_start_direction.normalized() * MAX_RAY_DIST
		ray.force_raycast_update()
		
		#count the number of times the laser has bounced
		var bounces: int = 0;
		
		while true:
			# check if we are not colliding with anything
			if not ray.is_colliding():
				var pt = ray.global_position + ray.target_position
				line.add_point(line.to_local(pt))
				break
			
			# get the collider that was collided with and collision point
			var coll := ray.get_collider()
			var pt: Vector2 = ray.get_collision_point()
			
			line.add_point(line.to_local(pt))
			
			# check if we have reached the max number of bounces
			if bounces >= MAX_BOUNCES:
				break
				
			# Check what we collided with and handle the collision
			if coll.is_in_group("Mirrors"):
				var success = process_mirror_collision(coll, pt)
				bounces += 1
				if success == false:
					break
			elif coll.is_in_group("Splitters"):
				process_splitter_collision(coll, pt, ray)
				break
			else:
				break
