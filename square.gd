extends ColorRect

class_name Square

## Properties
var access_value: int
var visited: bool

@export var dark: bool = false:
	set(v):
		dark = v
		set_square_color()
		
@export var model_resource : SquareModel
## Theme Colors
const COLORS = {
	"white": Color.FLORAL_WHITE, 
	"black": Color.BLACK, 
	"visited_square_light": Color.LIGHT_BLUE, 
	"visited_square_dark": Color.DARK_SLATE_GRAY, 
	"visited_text_light": Color.DARK_SLATE_BLUE, 
	"visited_text_dark": Color.BISQUE,
	"hover_square": Color.DARK_KHAKI,
	"hover_text": Color.MIDNIGHT_BLUE
}

## UI References
@onready var move_number_label: Label = $labelHolder/MoveNumberLabel
@onready var access_value_label: Label = $labelHolder/AccessValueLabel

## Signals
signal mouse_in_square(square: Square)
signal mouse_left_square(square: Square)

## Called when the node enters the scene tree
func _ready() -> void:
	update_square()

## ======= UI & Appearance Updates =======
func update_square() -> void:
	set_square_color()
	set_font_color()

func set_square_color() -> void:
	if visited:
		set_square_selected()
	else:
		color = COLORS["black"] if dark else COLORS["white"]

func set_font_color() -> void:
	var text_color: Color
	if not visited: 
		text_color = Color.WHITE if dark else Color.BLACK
	else:
		text_color = COLORS["visited_text_dark"] if dark else COLORS["visited_text_light"]
	move_number_label.add_theme_color_override("font_color", text_color)
	access_value_label.add_theme_color_override("font_color", text_color)

func set_square_selected() -> void:
	if dark:
		color = COLORS["visited_square_dark"]
	else:
		color = COLORS["visited_square_light"]
	set_font_color()

func set_square_hover():
	move_number_label.add_theme_color_override("font_color", COLORS["hover_text"])
	access_value_label.add_theme_color_override("font_color", COLORS["hover_text"])
	color = COLORS["hover_square"]

## ======= Setters & Getters =======
func get_square_model() -> SquareModel:
	return model_resource
	
func set_grid_position(pos : Vector2i):
	model_resource.set_grid_position(pos)

func set_move_number(value: int) -> void:
	model_resource.set_move_number(value)
	update_move_label()

func set_access_value(value: int) -> void:
	access_value = value
	model_resource.set_access_value(value)
	update_access_label()

func get_access_value() -> int:
	return access_value

func set_visited(value: bool) -> void:
	visited = value
	model_resource.set_visited(value)

func get_visited() -> bool:
	return visited

func set_dark(value: bool) -> void:
	dark = value
	update_square()

func get_dark() -> bool:
	return dark

## ======= Label Updates =======
func update_move_label() -> void:
	move_number_label.text = str(model_resource.get_move_number())

func update_access_label() -> void:
	access_value_label.text = str(model_resource.get_access_value())

## ======= Signal Handlers =======
func _on_mouse_entered() -> void:
	if not visited:
		mouse_in_square.emit(self)

func _on_mouse_exited() -> void:
	if not visited:
		mouse_left_square.emit(self)
