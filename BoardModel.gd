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

const MOVES = {
	1 : [2, -1], 
	2 : [1, -2], 
	3 : [-1, -2], 
	4 : [-2, -1], 
	5 : [-2, 1], 
	6 : [-1, 2], 
	7 : [1, 2], 
	8 : [2, 1]
	}

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
func get_available_moves(row, col) -> Array:
	var moves:= []
	for move in range(1, 9):
		var row_test = row + MOVES[move][1]
		var col_test = col + MOVES[move][0]
		if(valid_square(row_test, col_test)):
			moves.append([row_test, col_test])
	return moves		
	
func run_heuristic_tour(pos : Vector2i) -> bool:
	var knightPosition = [0,0] 
	knightPosition[1] = pos.y
	knightPosition[0] = pos.x
	var first_square : SquareModel = board_data[knightPosition[0]][knightPosition[1]]
	first_square.set_move_number(move_counter)
	first_square.set_visited(true)
	update_access_for_available_moves(get_available_moves(knightPosition[0], knightPosition[1]))
	move_counter += 1
	while(true):
		var moves = get_available_moves(knightPosition[0], knightPosition[1])
		if move_counter == 65:
			break
		if moves.size() < 1:
			break
		var move = pick_best_move(moves)
		knightPosition = move
		board_data[move[0]][move[1]].set_move_number(move_counter)
		board_data[move[0]][move[1]].set_visited(true)
		update_access_for_available_moves(moves)
		print("("+ board_data[move[0]][move[1]].toString())
		move_counter += 1
	tour_complete = move_counter == 65
	return move_counter == 65
	

func update_access_for_available_moves(moves : Array):
	if moves.size() < 1:
		return
	for move in moves:
		board_data[move[0]][move[1]].update_access_value()

"""
pick the best move from available moves
each move in moves is a position on the board
"""	
func pick_best_move(moves : Array):
	var low_access = 10
	var low_move = -1
	for move in moves:
		print(str(move))
		var access_val = board_data[move[0]][move[1]].get_access_value()
		if access_val < low_access:
			low_access = access_val
			low_move = move
	return low_move
	
func valid_square(row, col) -> bool:
	if board_data.is_empty():
		return false
	if row < 0 or row >= board_data.size():
		return false
	if col < 0 or col >= board_data[0].size():
		return false
	return !board_data[row][col].get_visited()
	#var square : SquareModel = board_data[row][col]
	#return !square.visited
	
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
		all_cells += row_cells + "\n"
	print(all_cells)
