extends StaticBody2D

func move_to_pos(position_to_move: Vector2):
	global_position = position_to_move

func rotate_towards_point(point):
	look_at(point)
