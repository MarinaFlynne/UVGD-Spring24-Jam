extends Node2D

@export var LeftWall: StaticBody2D
@export var RightWall: StaticBody2D

func move_to_pos(position_to_move: Vector2):
	global_position = position_to_move
	
func enable():
	LeftWall.add_to_group("Splitters")
	RightWall.add_to_group("Splitters")
	pass
	
func disable():
	LeftWall.remove_from_group("Splitters")
	RightWall.remove_from_group("Splitters")
	pass


func _on_drag_comp_delete_me():
	queue_free()
