extends SubViewport
@export var board_scene : PackedScene
@onready var sub_viewport: SubViewport = $"."
@onready var heuristic: Button = $"../../../Control2/VBoxContainer/Heuristic"
@onready var user_input: Button = $"../../../Control2/VBoxContainer/UserInput"

var board : Board
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_board: Board = board_scene.instantiate()
	add_child(new_board)
	board = sub_viewport.get_child(0)
	size = Vector2i(board.TILE_SIZE * 8, board.TILE_SIZE * 8)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_heuristic_pressed() -> void:
	board.heuristic_state = true
	board.user_input_state = false
	user_input.disabled = true


func _on_user_input_pressed() -> void:
	board.heuristic_state = false
	board.user_input_state = true
	heuristic.disabled = true
