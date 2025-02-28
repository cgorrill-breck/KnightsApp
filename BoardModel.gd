class_name BoardModel
extends Resource

@export var square_model_resource : SquareModel

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
		for square in board[i]:  # Iterate over squares in row
			board_data[i].append(square.model_resource)

func get_available_moves(row, col) -> Array:
	var moves:= []
	for move in range(1, 9):
		var row_test = row + MOVES[move][1]
		var col_test = col + MOVES[move][0]
		if(valid_square(row_test, col_test)):
			moves.append([row_test, col_test])
	return moves		
	
func valid_square(row, col) -> bool:
	if board_data.is_empty():
		return false
	if row < 0 or row >= board_data.size():
		return false
	if col < 0 or col >= board_data[0].size():
		return false
	return true
	#var square : SquareModel = board_data[row][col]
	#return !square.visited
	
