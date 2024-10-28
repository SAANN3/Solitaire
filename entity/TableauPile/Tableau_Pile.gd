class_name Tableau_Pile
extends Card_Controller

@onready var pile: VBoxContainer = $CenterContainer/pile
@onready var area: Area2D = $Control/Area2D
var accepting: bool = false

func _ready() -> void:
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

func load_cards(_cards: Array[Card]) -> void:
	for i: Card in _cards: 
		if _cards.find(i) + 1 < _cards.size() :
			i.flip()
	super(_cards)

func _on_card_left() -> void:
	if cards.size() > 0: 
		cards[cards.size() - 1].flip()
