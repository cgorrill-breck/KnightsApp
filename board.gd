extends Node2D

## Properties
var square_grid: Array = []  # 2D array for grid
@export var square: PackedScene  # Assigned in the inspector
@export var board_model_resource : BoardModel
var active_square: Square

## Called when the node enters the scene tree
func _ready() -> void:
	fill_grid(8, 8)
	connect_square_signals()
	board_model_resource.fill_board(square_grid)

## Handle user input
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse_button") and active_square:
		handle_square_click()
		var mouse_pos = get_global_mouse_position()
		var moves : Array = board_model_resource.get_available_moves(int(mouse_pos.y / 64), int(mouse_pos.x / 64))
		for move in moves:
			print(str(move[0])+", "+str(move[1]))

## ======= Grid Setup =======
func fill_grid(rows: int, cols: int) -> void:
	square_grid.clear()
	var dark := false
	
	for i in range(rows):
		var row: Array = []
		for j in range(cols):
			var new_square: Square = square.instantiate()
			
			add_child(new_square)  # Must be added before modifying position
			new_square.position = Vector2(j * 64, i * 64)  # Set position

			new_square.set_dark(dark)  # Set color theme
			new_square.update_square()  # Update appearance
			
			row.append(new_square)
			dark = !dark  # Toggle color
		
		square_grid.append(row)
		dark = !dark  # Toggle again at end of row

## ======= Signal Handling =======
func connect_square_signals() -> void:
	for row in square_grid:
		for square: Square in row:
			square.mouse_in_square.connect(_on_square_mouse_entered)
			square.mouse_left_square.connect(_on_square_mouse_exited)

func _on_square_mouse_entered(square: Square) -> void:
	active_square = square
	active_square.set_square_hover()
	var mouse_pos = get_local_mouse_position()
	highlight_available_squares(int(mouse_pos.y / 64), int(mouse_pos.x /64))
	
func _on_square_mouse_exited(square: Square) -> void:
	square.update_square()  # Reset to original color
	active_square = null

## ======= Game Logic =======
func handle_square_click() -> void:
	active_square.set_move_number(active_square.model_resource.get_move_number() + 1)
	active_square.update_move_label()
	active_square.set_visited(true)
	active_square.update_square()
	
func highlight_available_squares(row, col):
	var available_moves = board_model_resource.get_available_moves(row, col)
	for move in available_moves:
		print("Mouse:" + str(row)+","+str(col))
		print("Move: " + str(move[1]) + "," + str(move[0]))
		square_grid[move[0]][move[1]].color = Color.YELLOW
		
