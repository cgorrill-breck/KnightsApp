extends Node2D
@onready var board: Board = $".."
@onready var board_model = board.board_model_resource
var path_counter = 0
	
func _draw() -> void:
	draw_path()

func draw_path():
	var path : Array = board_model.tour_path
	#print(str(board.board_model_resource.tour_path))
	if path.is_empty():
		return
	
	# Get the first position
	var prev_pos = path[0] + Vector2i(board.TILE_SIZE / 2, board.TILE_SIZE / 2)
	
	# Draw path lines
	for i in range(1, path.size()):
		var next_pos = path[i] + Vector2i(board.TILE_SIZE / 2, board.TILE_SIZE / 2)
		
		draw_line(prev_pos, next_pos, Color.GREEN, 3.0)
		prev_pos = next_pos
	
	# Draw start position marker
	draw_circle(path[0] + Vector2i(board.TILE_SIZE / 2, board.TILE_SIZE / 2), 50, Color.RED, false, 3.0, true)
	draw_circle(path[-1] + Vector2i(board.TILE_SIZE / 2, board.TILE_SIZE / 2), 50, Color.RED, false, 3.0, true)

	
