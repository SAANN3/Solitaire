class_name Root_Scene
extends Node

@onready var card_holder: Card_holder = $Main/TopHcontainer/CardHolder
@onready var tableau_piles: Array[Tableau_Pile] = []
@onready var timer: Timer = $Timer
@onready var points_label: Label = $Main/HBoxContainer/points
@onready var time_label: Label = $Main/HBoxContainer/time
@onready var moves_label: Label = $Main/HBoxContainer/moves

var points: int = 0
var seconds_passed: int = 0
var moves: int = 0

func _ready() -> void:
	card_holder.holder_recycled.connect(_on_recycled)
	timer.timeout.connect(_on_timeout)
	card_holder.holder_clicked.connect(_on_card_holder_clicked)
	timer.start()
	var cards: Array[Card] = []
	for rank: int in Card.CardRank.values():
		for suit: int in Card.Suit.values():
			var card: Card = Card.spawn(rank, suit)
			card.card_moved.connect(_on_card_moved)
			cards.append(card)
	cards.shuffle()
	var pos: int = 0
	for i: int in range(1,8):
		var tableau: Tableau_Pile = get_node("Main/TableauHbox/TableauPile%d" % i)
		tableau.load_cards(cards.slice(pos,pos+i))
		pos += i
		tableau_piles.append(tableau)
	card_holder.load_cards(cards.slice(pos,cards.size()))


func _on_card_moved(old_parent: Card_Controller, new_parent: Card_Controller) -> void:
	if new_parent is Foundation && !old_parent is Foundation :
		_update_points(10)
	if old_parent is Foundation && new_parent is Tableau_Pile:
		_update_points(-15)
	if old_parent is Card_holder:
		_update_points(5)
	_update_moves()

func _on_recycled() -> void:
	_update_points(-20)



func _on_timeout() -> void:
	seconds_passed += 1
	if seconds_passed % 10 == 0:
		_update_points(-3)
	_update_time()
	

func _on_card_holder_clicked() -> void:
	_update_moves()

func _update_points(change: int) -> void:
	points += change
	points_label.text = "score : " + str(points)	

func _update_moves() -> void:
	moves += 1
	moves_label.text = "moves : " + str(moves)

func _update_time() -> void:
	var hours: int = seconds_passed / (60 * 60)
	var minutes: int = (seconds_passed / 60) % 60
	var seconds: int = seconds_passed % 60
	var string: String = "00:00"
	if minutes >= 10:
		string[0] = str(minutes)[0]
		string[1] = str(minutes)[1]
	else:
		string[1] = str(minutes)
	if seconds >= 10:
		string[3] = str(seconds)[0]
		string[4] = str(seconds)[1]
	else:
		string[4] = str(seconds)
	if hours > 0:
		string = str(hours) + ":" + string
	time_label.text = string
	

func _process(delta: float) -> void:
	pass
