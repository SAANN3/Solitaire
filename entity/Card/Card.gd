class_name Card
extends CenterContainer

@onready var root_texture: TextureRect = get_node("Bg")
@onready var rank_labels: Array[Label] = [
	get_node("Bg/TextureHolder/HBoxContainer/Label")
	#get_node("Bg/TextureHolder/Control/Label2")
]
@onready var suit_texture: TextureRect = get_node("Bg/TextureHolder/SuitTexture")
@onready var reversed_side_texture: TextureRect = get_node("ReverseSide")

var mouse_inside: bool = false
var moving: bool = false
var enabled: bool = false
var reversed: bool = false
var old_pos: Vector2
var default_pos: Vector2
var old_z: int
var rank: CardRank
var future_parents: Array[Card_Controller] = []
var parent: Card_Controller = null
var suit: Suit
var color: CardColor


static var _CardColorsTextures: Array[Texture2D] = [
	load("res://sprites/Suit/hearts.svg"),
	load("res://sprites/Suit/diamonds.svg"),
	load("res://sprites/Suit/spades.svg"),
	load("res://sprites/Suit/clubs.svg"),]
enum Suit {HEARTS, DIAMONDS, SPADES, CLUBS}
enum CardColor {RED, DARK}
enum CardRank {ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

signal card_moved(old_parent: Card_Controller, new_parent: Card_Controller)
signal card_flipped(reversed: bool)

static func spawn(_rank: CardRank, _suit: Suit) -> Card:
	var card: Card = preload("res://entity/Card/Card.tscn").instantiate()
	card.rank = _rank
	card.suit = _suit
	card.color = CardColor.RED if _suit <= 1 else CardColor.DARK
	return card

func _ready() -> void:
	_set_rank_font_size(1)
	root_texture.connect("mouse_entered", func() -> void: _on_mouse_entered(true))
	root_texture.connect("mouse_exited",  func() -> void: _on_mouse_entered(false))
	suit_texture.texture = _CardColorsTextures[suit]
	if rank > CardRank.ACE && rank < CardRank.JACK: 
		_set_rank_text(str(rank + 1))
	else :
		_set_rank_text(CardRank.find_key(rank)[0])
	flip(false)
	
func _process(delta: float) -> void:
	
	if moving && old_pos:	
		position += get_global_mouse_position() - old_pos
		old_pos = get_global_mouse_position()

func flip(change: bool = true) -> void:
	if change:
		reversed = !reversed
		card_flipped.emit(reversed)
	if reversed_side_texture && root_texture:
		if reversed:
			reversed_side_texture.visible = true
			root_texture.visible = false
		else:
			reversed_side_texture.visible = false
			root_texture.visible = true
	

func _set_rank_text(text: String) -> void:
	for i: Label in rank_labels: 
		i.text = text

func _set_rank_font_size(size: int) -> void:
	for i: Label in rank_labels:
		if Config.mobile:
			i.add_theme_font_size_override("font_size", 68)
		else:
			i.add_theme_font_size_override("font_size", 24)
		if color == CardColor.RED:
			i.add_theme_color_override("font_color","#cf1259")
		else:
			i.add_theme_color_override("font_color","#0A100D")
func _on_mouse_entered(state: bool) -> void:
	mouse_inside = state

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && enabled:
		if mouse_inside && event.is_pressed():
			old_z = z_index
			default_pos = position
			moving = true
			z_index = 99
			old_pos = get_global_mouse_position()
		if moving && !event.is_pressed():
			if future_parents.size() > 0:
				var closest_parent: Card_Controller = null
				var length_closest: float = 0.0
				for i: Card_Controller in future_parents:
					if parent == i:
						continue
					if !i.can_enter(self):
						continue
					if closest_parent:
						var new_length: float = self.get_global_rect().get_center().distance_to(i.get_global_rect().get_center())
						if new_length < length_closest:
							closest_parent = i
							length_closest = new_length
					else:
						closest_parent = i
						length_closest = self.get_global_rect().get_center().distance_to(i.get_global_rect().get_center())
				if closest_parent && closest_parent.can_enter(self):
					if parent:
						card_moved.emit(parent,closest_parent)
						parent.leave(self)
						closest_parent.enter(self)
				future_parents.clear()
			moving = false
			position = default_pos
			z_index = old_z




func _exit_tree() -> void:
	enabled = false
