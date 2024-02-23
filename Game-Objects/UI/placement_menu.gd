extends Node2D

@export var mirror_button: TextureButton
@export var splitter_button: TextureButton
@export var delete_button: TextureButton
var active_button: String
const mirror_scene_path = "res://Game-Objects/mirror.tscn"
const splitter_scene_path = "res://Game-Objects/splitter.tscn"

var mirror_scene = preload(mirror_scene_path)
var splitter_scene = preload(splitter_scene_path)

signal mirror_place(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mirror_button_pressed():
	active_button = "mirror"
	Globals.deletion_mode_active = false
	splitter_button.button_pressed = false
	delete_button.button_pressed = false

func _on_splitter_button_pressed():
	active_button = "splitter"
	Globals.deletion_mode_active = false
	mirror_button.button_pressed = false
	delete_button.button_pressed = false
	
func _on_delete_button_pressed():
	active_button = "delete"
	Globals.deletion_mode_active = true
	mirror_button.button_pressed = false
	splitter_button.button_pressed = false

func _on_big_placing_button_pressed():
	var mouse_pos = get_viewport().get_mouse_position()
	place_object(active_button, mouse_pos)
	print("pressed")
	
func place_object(obj_name: String, placement_position: Vector2):
	var object_to_place
	match obj_name:
		"mirror":
			object_to_place = mirror_scene.instantiate()
		"splitter":
			object_to_place = splitter_scene.instantiate()
		_:
			return
	
	add_child(object_to_place)
	object_to_place.global_position = placement_position
	
	
	

