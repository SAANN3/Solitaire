class_name Card_Controller
extends Control

var cards: Array[Card] = []
var cards_holder: Node = null
var collision: Node = null


func _ready() -> void:
	if collision:
		collision.connect("area_entered",func(area: Area2D) -> void: _on_collision(area,true))
		collision.connect("area_exited",func(area: Area2D) -> void: _on_collision(area,false))

func leave(card: Card) -> void:
	if cards.find(card) != -1:
		cards.remove_at(cards.find(card))
	_set_last_card(true)
	_on_card_left()

func enter(card: Card) -> void:
	_set_last_card(false)
	cards.append(card)
	card.parent = self
	if card.get_parent():
		card.reparent(cards_holder,false)
	else:
		cards_holder.add_child(card)
	_set_last_card(true)
	_on_card_enter()

func _set_last_card(state: bool) -> void:
	if cards.size() > 0:
		cards[cards.size() - 1].enabled = state

func _on_collision(area: Area2D, inside: bool) -> void:
	var card: Card = area.get_parent()
	if inside:
		card.future_parents.append(self)
	else:
		var pos: int = card.future_parents.find(self)
		if pos != -1:
			card.future_parents.remove_at(pos)

func load_cards(_cards: Array[Card]) -> void:
	cards = _cards
	for i: Card in cards:
		i.parent = self
		cards_holder.add_child(i)
	_set_last_card(true)

func _on_card_left() -> void:
	pass
	
func _on_card_enter() -> void:
	pass
	
func can_enter(card: Card) -> bool:
	return false

func save() -> Dictionary:
	return {
		"class": self.get_script().get_global_name(),
		"cards": cards.map(func (elem: Card) -> Dictionary: return elem.save())
	}

func load_dict(dict: Dictionary) -> void:
	if dict["cards"].size() > 0:
		var arr: Array[Card] = []
		arr.assign(dict["cards"].map(func (elem: Dictionary) -> Card: return Card.load_dict(elem)))
		load_cards(arr)
