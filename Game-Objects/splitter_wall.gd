extends StaticBody2D

@export var is_left_wall: bool
@export var new_laser_point: Node2D
@export var laser_through_point: Node2D

signal request_disable
signal request_enable

func enable():
	request_enable.emit()
	
func disable():
	request_disable.emit()
