extends Node2D

const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)
const UP_LEFT = Vector2(-1,-1)
const UP_RIGHT = Vector2(1,-1)
const DOWN_LEFT = Vector2(-1,1)
const DOWN_RIGHT = Vector2(1,1)
const DEFAULT_DIRECTION = DOWN

var current_direction = DEFAULT_DIRECTION
var direction_change_enabled: bool = true


enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}
signal direction_changed(direction_int)
# Called when the node enters the scene tree for the first time.
func _ready():
	change_direction_cardinal(current_direction)

## Takes a direction and changes the current direction to either up, down, left, or right.
func change_direction_cardinal(direction: Vector2):
	if direction_change_enabled:	
		var old_direction = current_direction
		current_direction = get_current_cardinal_direction(direction)
		if not current_direction == old_direction:
			direction_changed.emit(get_direction_int(current_direction))
			pass
		var angle = current_direction.angle()
		rotation = angle

func get_direction_int(direction: Vector2):
	match(direction):
		UP:
			return DIRECTIONS.UP
		RIGHT:
			return DIRECTIONS.RIGHT
		DOWN:
			return DIRECTIONS.DOWN
		LEFT:
			return DIRECTIONS.LEFT

## Takes a direction and returns either up, down, left, or right.
## For diagonal directions, prioritizes the current direction 
## (eg. if current_direction is UP, and we change give UP LEFT to this function,
## it will change direction to UP)
## If neither direction is current, prioritizes left/right
func get_current_cardinal_direction(direction: Vector2) -> Vector2:
	var cardinal_direction = direction
	match (direction):
		UP:
			cardinal_direction = UP
		DOWN:
			cardinal_direction = DOWN
		LEFT:
			cardinal_direction = LEFT
		RIGHT:
			cardinal_direction = RIGHT
		UP_LEFT:
			if direction.y == UP.y or direction.x == LEFT.x:
				cardinal_direction = current_direction
			else:
				cardinal_direction = LEFT
		UP_RIGHT:
			if direction.y == UP.y or direction.x == RIGHT.x:
				cardinal_direction = current_direction
			else:
				cardinal_direction = RIGHT
		DOWN_LEFT:
			if direction.y == DOWN.y or direction.x == LEFT.x:
				cardinal_direction = current_direction
			else:
				cardinal_direction = LEFT
		DOWN_RIGHT:
			if direction.y == DOWN.y or direction.x == RIGHT.x:
				cardinal_direction = current_direction
			else:
				cardinal_direction = RIGHT
		Vector2.ZERO:
			assert(false, "ERROR: ZERO VECTOR NOT ALLOWED")
		_:
			assert(false, "ERROR: INVALID DIRECTION %s" % direction)
	return cardinal_direction
