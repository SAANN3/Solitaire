class_name Settings
extends Control

enum Positioning {LEFT, RIGHT}

@onready var holder_layout_btn: CheckButton = $CenterContainer/HBoxContainer/CardHolderLayout/CheckButton

var holder_positioning: Positioning
var card_holder: Card_holder

func init(
	_card_holder: Card_holder	
) -> void:
	card_holder = _card_holder

func _ready() -> void:
	holder_layout_btn.toggled.connect(_holder_layout_change)

func _process(delta: float) -> void:
	pass

func _bool_to_position(state: bool) -> Positioning:
	return Positioning.RIGHT if !state else Positioning.LEFT

func _holder_layout_change(state: bool) -> void:
	var positioning: Positioning = _bool_to_position(state)
	var result: int = LAYOUT_DIRECTION_LTR if positioning == Positioning.LEFT else LAYOUT_DIRECTION_RTL
	card_holder.get_parent().set_layout_direction(result)
