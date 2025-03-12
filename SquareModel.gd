class_name SquareModel
extends Resource
@export var move_number: int
@export var access_value: int
@export var visited: bool
@export var position: Vector2i

signal move_number_updated(SquareModel)
signal access_value_updated(SquareModel)
signal visited_updated(SquareModel)

func set_grid_position(pos: Vector2i):
	if pos:
		position = pos
	
func get_grid_position() -> Vector2i:
	return position

func set_move_number(value: int) -> void:
	move_number = value
	move_number_updated.emit(self)

func get_move_number() -> int:
	return move_number

func set_access_value(value: int) -> void:
	access_value = value
	access_value_updated.emit(self)

func update_access_value() -> void:
	access_value -= 1
	access_value_updated.emit(self)

func get_access_value() -> int:
	return access_value

func set_visited(value: bool) -> void:
	visited = value
	visited_updated.emit(self)
	

func get_visited() -> bool:
	return visited

func toString() -> String:
	return "Move number: " + str(move_number) + " Access: " + str(access_value) + " Visited: " + str(visited)
