class_name BoardModel
extends Resource

@export var square_model_resource : SquareModel
var tour_path = []
var move_counter = 1;
var tour_complete = false

const INITIAL_ACCESS_VALUES = [
	[2, 3, 4, 4, 4, 4, 3, 2],
	[3, 4, 6, 6, 6, 6, 4, 3],
	[4, 6, 8, 8, 8, 8, 6, 4],
	[4, 6, 8, 8, 8, 8, 6, 4],
	[4, 6, 8, 8, 8, 8, 6, 4],
	[4, 6, 8, 8, 8, 8, 6, 4],
	[3, 4, 6, 6, 6, 6, 4, 3],
	[2, 3, 4, 4, 4, 4, 3, 2]
]

const MOVES = [
	Vector2i(2, -1),
	Vector2i(1, -2),
	Vector2i(-1, -2),
	Vector2i(-2, -1),
	Vector2i(-2, 1),
	Vector2i(-1, 2),
	Vector2i(1, 2),
	Vector2i(2, 1),
]

var board_data: Array = []

func fill_board(board: Array):
	board_data.clear()
	for i in range(board.size()):  # Iterate by index
		board_data.append([])  # Create a new row
		for square: Square in board[i]:  # Iterate over squares in row
			board_data[i].append(square.model_resource)
	set_initial_access_values(board)
			
func set_initial_access_values(board: Array):
	for i in range(board.size()):
		for j in range(board[i].size()):
			var square : Square = board[i][j]
			board[i][j].set_access_value(INITIAL_ACCESS_VALUES[i][j])
"""
return an array of valid board positions from the current knight position
"""
func get_available_moves(pos : Vector2i) -> Array:
	var moves:= []
	for move in range(0, 8):
		var check_pos : Vector2i = pos + MOVES[move]
		if(valid_square(check_pos)):
			moves.append(check_pos)
	return moves		
	
func run_heuristic_tour(pos : Vector2i, tile_size) -> bool:
	var knightPosition = pos
	
	var first_square : SquareModel = board_data[knightPosition.y][knightPosition.x]
	print(str(pos) + ", " + str(first_square.get_grid_position()))
	tour_path.append(Vector2i(knightPosition.y * tile_size, knightPosition.x * tile_size))
	first_square.set_move_number(move_counter)
	first_square.set_visited(true)
	update_access_for_available_moves(get_available_moves(knightPosition))
	move_counter += 1
	while(true):
		var moves = get_available_moves(knightPosition)
		if move_counter == 65:
			break
		if moves.size() < 1:
			break
		var move = pick_best_move(moves)
		
		knightPosition = move
		board_data[move.y][move.x].set_move_number(move_counter)
		board_data[move.y][move.x].set_visited(true)
		tour_path.append(Vector2i(move.y * tile_size, move.x * tile_size))# added (col == x, row == y)
		
		update_access_for_available_moves(moves)
		move_counter += 1
	tour_complete = move_counter == 65
	
	return move_counter == 65
	

func update_access_for_available_moves(moves: Array):
	if moves.size() < 1:
		return
	for move in moves:
		board_data[move.y][move.x].update_access_value()
		

"""
pick the best move from available moves
each move in moves is a position on the board
"""	
func pick_best_move(moves: Array):
	var low_access = 10
	var low_move = moves[0]  # Default to the first move to avoid returning -1
	for move in moves:
		var access_val = board_data[move.y][move.x].get_access_value()
		if access_val < low_access:
			low_access = access_val
			low_move = move
	return low_move

func reset_board_data():
	for row in range(board_data.size()):
		for col in range(board_data[row].size()):
			board_data[row][col].set_move_number(0)	
			board_data[row][col].set_access_value(INITIAL_ACCESS_VALUES[row][col])
	
func valid_square(pos : Vector2i) -> bool:
	if board_data.is_empty():
		return false
	if pos.y < 0 or pos.y >= board_data.size():
		return false
	if pos.x < 0 or pos.x >= board_data[0].size():
		return false
	return !board_data[pos.y][pos.x].get_visited()  
	
func get_move_counter():
	return move_counter;
	
func update_move_counter():
	move_counter += 1

func update_tour_path(pos : Vector2i):
	tour_path.append(pos)

func print_board():
	var all_cells := ""
	for row in board_data:
		var row_cells:= ""
		for square : SquareModel in row:
			row_cells += str(square.get_move_number()) + ", "
			row_cells += str(square.get_access_value()) + ", "
			row_cells += str(square.get_visited()) + ", "
		all_cells += row_cells + "\n"
	print(all_cells)
