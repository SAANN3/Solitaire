class_name Foundation
extends Card_Controller

@onready var pile: Control = $pile
@onready var area: Area2D = $Area2D

func _ready() -> void:
	cards_holder = pile
	collision = area
	super()

func _process(delta: float) -> void:
	pass

func can_enter(card: Card) -> bool:
	if cards.size() > 0:
		var last_card: Card = cards[cards.size() - 1]
		if last_card.rank == card.rank - 1 && last_card.color == card.color && last_card.suit == card.suit:
			return true
		else:
			return false
	elif card.rank == Card.CardRank.ACE:
		return true
	else:
		return false
