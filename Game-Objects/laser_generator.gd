extends Node2D

@export var max_ray_dist: int = 1000
@export_dir var laser_ray_path
var laser_array: Array
var starting_ray
var starting_direction

const laser_ray_scene = preload("res://Game-Objects/laser_ray.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	starting_direction = (get_global_mouse_position() - global_position).normalized()
	starting_ray = laser_ray_scene.instantiate()
	starting_ray.laser_start_direction = starting_direction
	starting_ray.new_laser_req.connect(new_laser_request)
	add_child(starting_ray)
	laser_array.append(starting_ray)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(1, laser_array.size()):
		var laser = laser_array.pop_back()
		laser.queue_free()
	starting_direction = (get_global_mouse_position() - global_position).normalized()
	starting_ray.laser_start_direction = starting_direction
	for laser in laser_array:
		laser.process_laser()
		
# called when a laser emits a signal requesting a new laser ray
func new_laser_request(starting_pt: Vector2, direction: Vector2):
	var new_laser = laser_ray_scene.instantiate()
	#print(new_laser.global_position)
	#print(new_laser.ray.global_position)
	new_laser.laser_start_direction = direction
	new_laser.new_laser_req.connect(new_laser_request)
	add_child(new_laser)
	new_laser.global_position = starting_pt
	laser_array.append(new_laser)
	
	
	
