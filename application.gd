extends Node2D
@onready var heuristic = $GUIcontainer/HBoxContainer/Control2/VBoxContainer/Heuristic
@onready var user_input = $GUIcontainer/HBoxContainer/Control2/VBoxContainer/UserInput
@onready var reset = $GUIcontainer/HBoxContainer/Control2/VBoxContainer/Reset
@onready var sub_viewport = $GUIcontainer/HBoxContainer/Control/SubViewportContainer/SubViewport
@onready var heuristic_64: Button = $GUIcontainer/HBoxContainer/Control2/VBoxContainer/Heuristic64
var board : Board


# Called when the node enters the scene tree for the first time.
func _ready():
	board = sub_viewport.get_child(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_heuristic_pressed() -> void:
	board.heuristic_state = true
	board.user_input_state = false
	board.heuristic_64_state = false
	user_input.set_disabled(true)
	heuristic_64.set_disabled(true)
	print("heuristic pressed")


func _on_user_input_pressed() -> void:
	board.heuristic_state = false
	board.user_input_state = true
	board.heuristic_64_state = false
	heuristic.set_disabled(true)
	heuristic_64.set_disabled(true)
	print("user input pressed")

func _on_heuristic_64_pressed() -> void:
	board.heuristic_state = false
	board.user_input_state = false
	board.heuristic_64_state = true
	user_input.set_disabled(true)
	heuristic.set_disabled(true)
	print("heuristic pressed")

func _on_reset_pressed():
	board.board_model_resource.reset_board_data()
	board.update_all_squares()
	board.update_all_square_colors()
	board.heuristic_state = false
	board.user_input_state = false
	user_input.set_disabled(false)
	heuristic.set_disabled(false)
	board.board_model_resource.print_board()
	board.board_model_resource.move_counter = 1
	board.board_model_resource.tour_complete = false
	board.board_model_resource.tour_path.clear()
	board.drawing.queue_redraw()
	board.drawing.path_counter = 0


func _on_board_visible_toggled(toggled_on: bool) -> void:
	if board.square_grid and board.square_grid.size() > 0:
		for row : Array in board.square_grid:
			for square : Square in row:
				square.visible = toggled_on;
	if not toggled_on:
		board.heuristic_state = false
		board.user_input_state = false
		heuristic.set_disabled(true)
		user_input.set_disabled(true)
		reset.set_disabled(true)
		board.capture_board_view_image()
	else:
		heuristic.set_disabled(false)
		user_input.set_disabled(false)
		reset.set_disabled(false)
