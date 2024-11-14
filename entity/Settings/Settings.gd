class_name Settings
extends Control

enum Positioning {LEFT, RIGHT}

@onready var holder_layout_btn: CheckButton = $CenterContainer/VBoxContainer/MarginContainer/HBoxContainer/CardHolderLayout/CheckButton
@onready var reset_btn: Button = $CenterContainer/VBoxContainer/MarginContainer/HBoxContainer/Reset/Button
@onready var close_btn: Button = $CenterContainer/VBoxContainer/CloseButton
@onready var top_panel_score_btn: CheckBox = $CenterContainer/VBoxContainer/MarginContainer/HBoxContainer/TopBar/HBoxContainer/Score/CheckBox
@onready var top_panel_time_btn: CheckBox = $CenterContainer/VBoxContainer/MarginContainer/HBoxContainer/TopBar/HBoxContainer/Time/CheckBox
@onready var top_panel_moves_btn: CheckBox = $CenterContainer/VBoxContainer/MarginContainer/HBoxContainer/TopBar/HBoxContainer/Moves/CheckBox
@onready var card_holder_max_cards_btn: CheckButton = $CenterContainer/VBoxContainer/MarginContainer/HBoxContainer/Draw/HBoxContainer/CheckButton

var card_holder: Card_holder
var top_panel: Top_Panel
var holder_positioning: Positioning
var top_panel_visible_moves: bool
var top_panel_visible_points: bool
var top_panel_visible_time: bool
var card_holder_max_cards: int

func init(
	_card_holder: Card_holder,
	_top_panel: Top_Panel,
) -> void:

	card_holder = _card_holder
	top_panel = _top_panel
	_init_vars()
	_init_gui()

func _init_vars() -> void:
	holder_positioning = _convert_LAYOUT_to_positioning(card_holder.get_parent().get_layout_direction())
	top_panel_visible_moves = top_panel.is_moves_visible()
	top_panel_visible_time = top_panel.is_time_visible()
	top_panel_visible_points = top_panel.is_points_visible()
	card_holder_max_cards = card_holder.get_max_cards()

func _init_gui() -> void:
	holder_layout_btn.button_pressed = _convert_position_to_bool(holder_positioning)
	top_panel_moves_btn.button_pressed = top_panel_visible_moves
	top_panel_score_btn.button_pressed = top_panel_visible_points
	top_panel_time_btn.button_pressed = top_panel_visible_time
	card_holder_max_cards_btn.button_pressed = card_holder_max_cards == 3
	
	top_panel_moves_btn.toggled.connect(top_panel.set_moves_visible)
	top_panel_score_btn.toggled.connect(top_panel.set_points_visible)
	top_panel_time_btn.toggled.connect(top_panel.set_time_visible)
	
	


func _ready() -> void:
	holder_layout_btn.toggled.connect(_holder_layout_change)
	close_btn.pressed.connect(func() -> void: self.visible = false)
	reset_btn.pressed.connect(get_tree().reload_current_scene)
	card_holder_max_cards_btn.toggled.connect(_set_max_cards)

func _set_max_cards(toggled: bool) -> void:
	if toggled:
		card_holder.set_max_cards(3)
	else:
		card_holder.set_max_cards(1)

func _convert_bool_to_position(state: bool) -> Positioning:
	return Positioning.RIGHT if state else Positioning.LEFT

func _convert_position_to_bool(position: Positioning) -> bool:
	return true if position == Positioning.RIGHT else false

func _convert_LAYOUT_to_positioning(layout: LayoutDirection) -> Positioning:
	return Positioning.RIGHT if layout == LAYOUT_DIRECTION_RTL else false

func _holder_layout_change(state: bool) -> void:
	var positioning: Positioning = _convert_bool_to_position(state)
	var result: int = LAYOUT_DIRECTION_LTR if positioning == Positioning.LEFT else LAYOUT_DIRECTION_RTL
	card_holder.get_parent().set_layout_direction(result)
	card_holder.set_layout_direction(result)
