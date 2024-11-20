class_name Root_Scene
extends Control

@onready var card_holder: Card_holder = $Main/MainScreen/Vbox/TopHcontainer/CardHolder
@onready var tableau_piles: Array[Tableau_Pile] = []
@onready var timer: Timer = $Timer
@onready var top_panel: Top_Panel = $Main/TopPanel/TopPanel
@onready var UI_pabel: Control = $UiPanel
@onready var UI_label: Label = $UiPanel/VBoxContainer/Label
@onready var UI_restart: Button = $UiPanel/VBoxContainer/Button
@onready var bottom_panel: Bottom_Panel = $Main/BottomPanel/Settings

var points: int = 0
var seconds_passed: int = 0
var moves: int = 0
var completed_foundations: Array[Foundation] = []
var safe_offset: Rect2i = Rect2i()
var safe_area: Rect2i = DisplayServer.get_display_safe_area()

func _ready() -> void:
	if !Config.mobile:
		theme.set_font_size("font_size","Label",16)
		theme.set_font_size("font_size","Button",16)
	card_holder.holder_recycled.connect(_on_recycled)
	timer.timeout.connect(_on_timeout)
	card_holder.holder_clicked.connect(_on_card_holder_clicked)
	bottom_panel.panel_change.connect(_on_panel_change)
	timer.start()
	UI_restart.pressed.connect(_on_win_button_clicked)
	var cards: Array[Card] = []
	for rank: int in Card.CardRank.values():
		for suit: int in Card.Suit.values():
			var card: Card = Card.spawn(rank, suit)
			card.card_moved.connect(_on_card_moved)
			card.card_flipped.connect(_on_card_flipped)
			cards.append(card)
	for i: int in range(0,4):
		var foundation: Foundation = get_node("Main/MainScreen/Vbox/TopHcontainer/Foundation%d" % i)
		foundation.completed.connect(func (state: bool) -> void: _on_foundation_completed(state, foundation))
	#_auto_win(cards)
	insert_cards(cards)
	bottom_panel.get_settings().init(
		card_holder,
		top_panel
	)


func insert_cards(cards: Array[Card]) -> void:
	cards.shuffle()
	var pos: int = 0
	for i: int in range(1,8):
		var tableau: Tableau_Pile = get_node("Main/MainScreen/Vbox/TableauHbox/TableauPile%d" % i)
		tableau.load_cards(cards.slice(pos,pos+i))
		pos += i
		tableau_piles.append(tableau)
	card_holder.load_cards(cards.slice(pos,cards.size()))

func _on_win_button_clicked() -> void:
	get_tree().reload_current_scene()

func _on_panel_change(visible: bool) -> void:
	if visible:
		timer.stop()
	else:
		timer.start()

func _auto_win(cards: Array[Card]) -> void: 
	var pos: int = 0 
	while pos < cards.size():
		for z: int in range(0,4):
			var foundation: Foundation = get_node("Main/MainScreen/Vbox/TopHcontainer/Foundation%d" % z)
			foundation.enter(cards[pos])
			pos += 1

func _on_card_flipped(looking_direction: bool) -> void:
	if (!looking_direction):
		_update_points(2)
	
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



func _on_foundation_completed(state:bool, foundation: Foundation) -> void:
	var pos: int = completed_foundations.find(foundation)
	if pos == -1 && state:
		completed_foundations.append(foundation)
	if pos != -1 && !state:
		completed_foundations.remove_at(pos)
	if completed_foundations.size() == 4:
		UI_pabel.visible = true
		UI_label.text = "You Won!"
		print("won")

func _on_timeout() -> void:
	seconds_passed += 1
	if seconds_passed % 10 == 0:
		_update_points(-3)
	_update_time()
	

func _on_card_holder_clicked() -> void:
	_update_moves()

func _update_points(change: int) -> void:
	points += change
	if points < 0:
		points = 0
	top_panel.set_points(points)	

func _update_moves() -> void:
	moves += 1
	top_panel.set_moves(moves)	

func _update_time() -> void:
	top_panel.set_time(seconds_passed)
	
