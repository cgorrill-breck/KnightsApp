extends Node2D
const TILE_SIZE:= 64
## Properties
var square_grid: Array = []  # 2D array for grid
var previous_squares: Array = []
@export var square: PackedScene  # Assigned in the inspector
@export var board_model_resource : BoardModel
var active_square: Square

## Called when the node enters the scene tree
func _ready() -> void:
	fill_grid(8, 8)
	connect_square_signals()
	board_model_resource.fill_board(square_grid)

## process for Heuristic Tour
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse_button") and !board_model_resource.tour_complete:
		var mouse_pos = get_local_mouse_position()
		var mouse_vector : Vector2i = Vector2i(int(mouse_pos.y / TILE_SIZE), int(mouse_pos.x / TILE_SIZE)) 
		handle_heuristic_tour(mouse_vector)
		
## Handle user input
#func _process(delta: float) -> void:
	#if not Input.is_action_just_pressed("left_mouse_button"):
		#return
	#if not active_square:
		#return
	#if board_model_resource.get_move_counter() > 1:
		#if square_in_previous(active_square):
			#handle_square_click()
			#update_access_values()
	#else:
		#handle_square_click()
		#update_access_values()
			
func square_in_previous(square: Square):
	var pos = [0,0]
	pos[1] = square.get_square_model().get_grid_position().y
	pos[0] = square.get_square_model().get_grid_position().x
	return pos in previous_squares;
	
## ======= Grid Setup =======
func fill_grid(rows: int, cols: int) -> void:
	square_grid.clear()
	var dark := false
	
	for i in range(rows):
		var row: Array = []
		for j in range(cols):
			var new_square: Square = square.instantiate()
			new_square.set_grid_position(Vector2i(i,j))
			add_child(new_square)  # Must be added before modifying position
			new_square.position = Vector2(j * TILE_SIZE, i * TILE_SIZE)  # Set position

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
	if previous_squares.size() != 0:
		var pos : Array = [square.get_square_model().get_grid_position().x, square.get_square_model().get_grid_position().y]
		if  pos not in previous_squares:
			active_square.set_square_hover()
	else:
		active_square.set_square_hover()
	
func _on_square_mouse_exited(square: Square) -> void:
	if previous_squares.size() != 0:
		var pos : Array = [square.get_square_model().get_grid_position().x, square.get_square_model().get_grid_position().y]
		if  pos not in previous_squares:
			square.update_square()  # Reset to original color
	else:
		square.update_square()
		active_square = null
	

## ======= Game Logic =======
func handle_square_click() -> void:
	var mouse_pos = get_local_mouse_position()
	if previous_squares.size() != 0:
		reset_squares(previous_squares)
	previous_squares = highlight_available_squares(int(mouse_pos.y / TILE_SIZE), int(mouse_pos.x / TILE_SIZE))
	active_square.set_move_number(board_model_resource.get_move_counter())
	board_model_resource.update_tour_path(active_square.global_position)# check on this.  Not sure if it will work
	board_model_resource.update_move_counter()
	active_square.update_move_label()
	active_square.set_visited(true)
	active_square.update_square()

func handle_heuristic_tour(pos : Vector2i):
	board_model_resource.run_heuristic_tour(pos)
	update_all_squares()

func update_all_squares():
	for i in range(board_model_resource.board_data.size()):
		for square : SquareModel in board_model_resource.board_data[i]:
			square_grid[square.get_grid_position()[0]][square.get_grid_position()[1]].set_move_number(square.get_move_number())
			square_grid[square.get_grid_position()[0]][square.get_grid_position()[1]].set_access_value(square.get_access_value())
			square_grid[square.get_grid_position()[0]][square.get_grid_position()[1]].visited = true
				
func update_access_values():
	for pos in previous_squares:
		square_grid[pos[0]][pos[1]].set_access_value(square_grid[pos[0]][pos[1]].get_access_value() - 1)

func reset_squares(squares: Array) -> void:	
	for pos : Array in squares:
		var squ : Square = square_grid[pos[0]][pos[1]]
		squ.update_square()
		
	
func highlight_available_squares(row, col) -> Array:
	var available_moves = board_model_resource.get_available_moves(row, col)
	for move in available_moves:
		var square : Square = square_grid[move[0]][move[1]]
		if !square.get_square_model().get_visited():
			square.color = Color.LIGHT_CORAL
	return available_moves
		
