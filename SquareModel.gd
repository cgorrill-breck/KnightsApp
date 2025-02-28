class_name SquareModel
extends Resource
@export var move_number: int
@export var access_value: int
@export var visited: bool

func set_move_number(value: int) -> void:
	move_number = value

func get_move_number() -> int:
	return move_number

func set_access_value(value: int) -> void:
	access_value = value

func get_access_value() -> int:
	return access_value

func set_visited(value: bool) -> void:
	visited = value

func get_visited() -> bool:
	return visited
