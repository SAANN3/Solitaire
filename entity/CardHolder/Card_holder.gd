class_name Card_holder
extends Card_Controller
@onready var stacker: Control = $Control/Stacker
@onready var stack_empty: TextureRect = $CenterContainer/StackEmpty
@onready var stack: TextureRect = $CenterContainer/Stack
@onready var animation: AnimationPlayer = $AnimationPlayer

var cards_discarded: Array[Card] = []
var cards_prepared: Array[Card] = []
var recycled: bool = false
var max_cards: int = 3
signal holder_recycled()
signal holder_clicked()

func _ready() -> void:
	$CenterContainer.gui_input.connect(_on_stack_input)
	cards_holder = $Control/Stacker
	super()

func _on_stack_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton && 
		event.button_index == MOUSE_BUTTON_LEFT && 
		get_global_rect().has_point(get_global_mouse_position()) && 
		event.is_pressed()
	):
		if !animation.is_playing():
			place_cards()
			animation.play("show_right" if layout_direction == LAYOUT_DIRECTION_RTL else "show" )

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
		stack_empty.visible = false
		stack.visible = true
		return
	for i: int in range(0,max_cards):
		var card: Card = cards_prepared.pop_front()
		if card != null:
			enter(card)
		else :
			break
	if cards_prepared.size() == 0:
		stack_empty.visible = true
		stack.visible = false
	holder_clicked.emit()
	return 

func load_cards(_cards: Array[Card]) -> void:
	cards_prepared = _cards

func save() -> Dictionary:
	var _dict: Dictionary = super()
	_dict.merge({
		"cards_discarded": cards_discarded.map(func (elem: Card) -> Dictionary: return elem.save()),
		"cards_prepared": cards_prepared.map(func (elem: Card) -> Dictionary: return elem.save()),
		"recycled": recycled,
	})
	return _dict

func load_dict(dict: Dictionary) -> void:
	cards_discarded.assign(dict["cards_discarded"].map(func (elem: Dictionary) -> Card: return Card.load_dict(elem)))
	cards_prepared.assign(dict["cards_prepared"].map(func (elem: Dictionary) -> Card: return Card.load_dict(elem)))
	recycled = dict["recycled"]
	for i: Dictionary in dict["cards"]:
		enter(Card.load_dict(i))
	if cards_prepared.size() == 0:
		stack_empty.visible = true
		stack.visible = false
