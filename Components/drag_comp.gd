extends Button

var is_button_down: bool = false

signal move_me(position_to_move)
signal rotate_me(point_to_rotate_towards: Vector2)
signal delete_me

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_button_down:
		if Input.is_action_pressed("left_click"):
			if Globals.deletion_mode_active:
				delete_me.emit()
			else:
				move_me.emit(get_viewport().get_mouse_position())
		elif Input.is_action_pressed("right_click"):
			rotate_me.emit(get_viewport().get_mouse_position())
		


func _on_button_down():
	is_button_down = true


func _on_button_up():
	is_button_down = false
