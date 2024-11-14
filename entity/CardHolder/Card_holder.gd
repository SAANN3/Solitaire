class_name Card_holder
extends Card_Controller
@onready var stacker: Control = $Stacker
@onready var stack: TextureRect = $Stack

var cards_discarded: Array[Card] = []
var cards_prepared: Array[Card] = []
var recycled: bool = false
var max_cards: int = 3
signal holder_recycled()
signal holder_clicked()

func _ready() -> void:
	stack.gui_input.connect(_on_stack_input)
	cards_holder = $Stacker
	super()

func _on_stack_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton && 
		event.button_index == MOUSE_BUTTON_LEFT && 
		get_global_rect().has_point(get_global_mouse_position()) && 
		event.is_pressed()
	):
		place_cards()

func get_max_cards() -> int:
	return max_cards

func set_max_cards(val: int) -> void:
	max_cards = val
func place_cards() -> void:
	if recycled:
		holder_recycled.emit()
		recycled = false
	for i: Card in cards:
		stacker.remove_child(i)
	cards_discarded.append_array(cards)
	cards.clear()
	if cards_prepared.size() == 0:
		cards_prepared.append_array(cards_discarded)
		cards_discarded.clear()
		recycled = true
		return
	for i: int in range(0,max_cards):
		var card: Card = cards_prepared.pop_front()
		if card != null:
			enter(card)
		else :
			break
	holder_clicked.emit()

func load_cards(_cards: Array[Card]) -> void:
	cards_prepared = _cards
