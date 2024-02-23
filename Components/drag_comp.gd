extends Button

var is_button_down: bool = false

signal move_me(position_to_move)

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_button_down:
		move_me.emit(get_viewport().get_mouse_position())


func _on_button_down():
	is_button_down = true


func _on_button_up():
	is_button_down = false
