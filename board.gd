extends Node2D
class_name Board
const NUM_ROWS = 8
const NUM_COLS = 8
const TILE_SIZE:= 128
## Properties
var square_grid: Array = []  # 2D array for grid
var previous_squares: Array = []
@export var square: PackedScene  # Assigned in the inspector
@export var board_model_resource : BoardModel
var active_square: Square
var heuristic_state = false
var user_input_state = false
@onready var drawing: Node2D = $Drawing

## Called when the node enters the scene tree
func _ready() -> void:
	fill_grid(NUM_ROWS, NUM_COLS)
	connect_square_signals()
	board_model_resource.fill_board(square_grid)
		
## Handle user input
func _process(delta: float) -> void:
	if user_input_state:
		if not Input.is_action_just_pressed("left_mouse_button"):
			return
		if not active_square:
			return
		if board_model_resource.get_move_counter() > 1:
			if square_in_previous(active_square):
				handle_square_click()
				update_access_values()
				
		else:
			handle_square_click()
			update_access_values()
			
	if heuristic_state:
		if Input.is_action_just_pressed("left_mouse_button") and !board_model_resource.tour_complete:
			var mouse_vector : Vector2i = get_local_mouse_position()
			var square_selected = Vector2i(int(mouse_vector.y / TILE_SIZE), int(mouse_vector.x / TILE_SIZE)) 
			handle_heuristic_tour(square_selected)	
		
				
func square_in_previous(square: Square):
	var pos : Vector2i = square.get_square_model().get_grid_position()
	return pos in previous_squares;
	
## ======= Grid Setup =======
func fill_grid(rows: int, cols: int) -> void:
	square_grid.clear()
	var dark := false
	
	for i in range(rows):
		var row: Array = []
		for j in range(cols):
			var new_square: Square = square.instantiate()
			new_square.size = Vector2i(TILE_SIZE, TILE_SIZE)
			new_square.set_grid_position(Vector2i(j,i))#+++++++++THIS MAY BE AN ISSUE++++++++++++++
			add_child(new_square)  # Must be added before modifying position
			new_square.position = Vector2(i * TILE_SIZE, j * TILE_SIZE)  # Set position
			new_square.update_position_label()
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
		var pos : Vector2i = square.get_square_model().get_grid_position()
		if  pos not in previous_squares:
			active_square.set_square_hover()
	else:
		active_square.set_square_hover()
	
func _on_square_mouse_exited(square: Square) -> void:
	if previous_squares.size() != 0:
		var pos : Vector2i = square.get_square_model().get_grid_position()
		if  pos not in previous_squares:
			square.update_square()  # Reset to original color
	else:
		square.update_square()
		active_square = null
	

## ======= Game Logic =======
func handle_square_click() -> void:
	var mouse_pos : Vector2i = get_local_mouse_position()
	if previous_squares.size() != 0:
		reset_squares(previous_squares)
	mouse_pos = Vector2i(int(mouse_pos.y / TILE_SIZE), int(mouse_pos.x / TILE_SIZE))
	previous_squares = highlight_available_squares(mouse_pos)
	active_square.set_move_number(board_model_resource.get_move_counter())
	board_model_resource.update_tour_path(active_square.global_position)# check on this.  Not sure if it will work
	board_model_resource.update_move_counter()
	active_square.update_move_label()
	active_square.set_visited(true)
	active_square.update_square()
	drawing.queue_redraw()

func handle_heuristic_tour(pos : Vector2i):
	board_model_resource.run_heuristic_tour(pos, TILE_SIZE)
	update_all_squares()
	drawing.queue_redraw()

func update_all_squares():
	for i in range(board_model_resource.board_data.size()):
		for square : SquareModel in board_model_resource.board_data[i]:
			square_grid[square.get_grid_position().y][square.get_grid_position().x].set_move_number(square.get_move_number())
			square_grid[square.get_grid_position().y][square.get_grid_position().x].set_access_value(square.get_access_value())
			square_grid[square.get_grid_position().y][square.get_grid_position().x].visited = true

func update_all_square_colors():
	for row in square_grid:
		for square: Square in row:
			square.set_visited(false)
			square.update_square()
				
func update_access_values():
	for pos in previous_squares:
		get_square_from_grid(pos).set_access_value(get_square_from_grid(pos).get_access_value() - 1)

func reset_squares(squares: Array) -> void:	
	for pos : Vector2i in squares:
		var squ : Square = get_square_from_grid(pos)
		squ.update_square()
		
	
func highlight_available_squares(pos : Vector2i) -> Array:
	var available_moves = board_model_resource.get_available_moves(pos)
	for move : Vector2i in available_moves:
		var square : Square = get_square_from_grid(move)
		if !square.get_square_model().get_visited():
			square.color = Color.LIGHT_CORAL
	return available_moves
	
	
func get_square_from_grid(pos : Vector2i) -> Square:
	return square_grid[pos.y][pos.x]	
