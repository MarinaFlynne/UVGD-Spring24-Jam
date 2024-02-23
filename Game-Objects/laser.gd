extends Node2D

@export var ray: RayCast2D
@export var line: Line2D
@export var max_bounces: int = 100

var laser_rays: Array

const MAX_RAY_DIST: int = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_mirror_collision(prev, coll, pt) -> bool:
	#process_mirror_collision(ray,prev,coll,pt)
	var normal = ray.get_collision_normal()
	
	# If the normal is ever zero, break. This can happen if we start out inside a mirror hitbox
	if normal == Vector2.ZERO:
		return false
		
	if prev != null:
		prev.set_collision_layer_value(1, true)
		prev.set_collision_layer_value(2, true)
		prev.set_collision_mask_value(1, true)
		prev.set_collision_mask_value(2, true)
		
	coll.set_collision_layer_value(1, false)
	coll.set_collision_layer_value(2, false)
	coll.set_collision_mask_value(1, false)
	coll.set_collision_mask_value(2, false)
	
	# new raycast
	ray.global_position = pt
	ray.target_position = ray.target_position.bounce(normal)
	ray.force_raycast_update()
	
	return true
	
func process_splitter_collision(prev, coll, pt):
	pass
	
func process_laser():
	#first line point is at 0,0
		line.add_point(Vector2.ZERO)
		
		# initialize ray
		ray.global_position = line.global_position
		# cast the ray
		ray.target_position = (get_global_mouse_position() - line.global_position).normalized() * MAX_RAY_DIST
		ray.force_raycast_update()
		
		# to keep track of the previous collider collided with
		var prev = null
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
			if bounces >= max_bounces:
				break
				
			# Check what we collided with and handle the collision
			if coll.is_in_group("Mirrors"):
				var success = process_mirror_collision(prev, coll, pt)
				prev = coll
				bounces += 1
				if success == false:
					break
			elif coll.is_in_group("Splitters"):
				#process_splitter_collision(prev, coll, pt)
				break
			else:
				break
		
		# out of the loop now. update collisions again
		if prev != null:
			prev.set_collision_layer_value(1, true)
			prev.set_collision_layer_value(2, true)
			prev.set_collision_mask_value(1, true)
			prev.set_collision_mask_value(2, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# make sure line is clear at the start of each frame
	line.clear_points()
	
	if Input.is_action_pressed("shoot_laser"):
		process_laser()
