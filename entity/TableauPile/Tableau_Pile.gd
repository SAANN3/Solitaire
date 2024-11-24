class_name Tableau_Pile
extends Card_Controller

@onready var pile: VBoxContainer = $CenterContainer/Container/pile
@onready var pileFlipped: VBoxContainer = $CenterContainer/Container/pileFlipped
@onready var pileContainer: VBoxContainer = $CenterContainer/Container
@onready var area: Area2D = $Control/Area2D

func _ready() -> void:
	if !Config.mobile:
		pile.add_theme_constant_override("separation",-205)
		pileFlipped.add_theme_constant_override("separation",-215)
		pileContainer.add_theme_constant_override("separation",-215)
	else:
		pile.add_theme_constant_override("separation",-170)
		pileFlipped.add_theme_constant_override("separation",-215)
		pileContainer.add_theme_constant_override("separation",-215)
	cards_holder = pile
	collision = area
	super()

func _process(delta: float) -> void:
	pass

func can_enter(card: Card) -> bool:
	if cards.size() > 0:
		var last_card: Card = cards[cards.size() - 1]
		if last_card.rank == card.rank + 1 && last_card.color != card.color:
			return true
		else:
			return false
	elif card.rank == Card.CardRank.KING:
		return true
	else:
		return false

func child_flipped_up(card: Card) -> void:
	card.reparent(pile)


func load_cards(_cards: Array[Card], flip: bool = true) -> void:
	cards = _cards
	for i: Card in _cards:
		i.parent = self
		i.enabled = true
		if _cards.find(i) + 1 < _cards.size() && flip && !i.not_reversed:
			pileFlipped.add_child(i)
			i.flip()
		else:
			cards_holder.add_child(i)
			i.enabled = true
	hide_pile_flipped()
	_set_last_card(true)

func enter(card: Card, disable_previous: bool = false) -> void:
	hide_pile_flipped()
	super(card, disable_previous)

func _on_card_left() -> void:
	if cards.size() > 0:
		if cards[cards.size() - 1].reversed: 
			cards[cards.size() - 1].flip()
	hide_pile_flipped()

func get_next_cards(card: Card) -> Array[Card]:
	return cards.slice(cards.find(card)+1) 

func hide_pile_flipped() -> void:
	if pileFlipped.get_child_count() == 0:
		pileFlipped.visible = false 
	
