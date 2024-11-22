class_name Settings
extends Base_Bottom

enum Positioning {LEFT, RIGHT}

@onready var holder_layout_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/CardHolderLayout/HBoxContainer/CheckButton
@onready var reset_btn: Button = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/Reset/Button
@onready var close_btn: Button = $CloseContainer/CloseButton
@onready var top_panel_score_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/TopBar/HBoxContainer/Score/CheckBox
@onready var top_panel_time_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/TopBar/HBoxContainer/Time/CheckBox
@onready var top_panel_moves_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/TopBar/HBoxContainer/Moves/CheckBox
@onready var card_holder_max_cards_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/Draw/HBoxContainer/CheckButton
@onready var orientation_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/Orientation/HBoxContainer/CheckButton
@onready var window_mode_btn: CheckBox = $CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/WindowMode/HBoxContainer/CheckButton

var card_holder: Card_holder
var top_panel: Top_Panel
var holder_positioning: Positioning

func init(
	_card_holder: Card_holder,
	_top_panel: Top_Panel,
) -> void:
	card_holder = _card_holder
	top_panel = _top_panel
	_init_gui()

func _init_gui() -> void:
	if !Config.mobile:
		$CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer.add_theme_constant_override("separation",10)
	top_panel_moves_btn.button_pressed = Config.settingsConf.top_panel_moves
	top_panel_score_btn.button_pressed = Config.settingsConf.top_panel_score
	top_panel_time_btn.button_pressed = Config.settingsConf.top_panel_time
	holder_layout_btn.button_pressed = _convert_position_to_bool(Config.settingsConf.layout)
	orientation_btn.button_pressed = Config.settingsConf.orientation == DisplayServer.ScreenOrientation.SCREEN_LANDSCAPE
	card_holder_max_cards_btn.button_pressed = Config.settingsConf.draw == 3
	window_mode_btn.button_pressed = Config.settingsConf.window_mode == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	_set_max_cards(Config.settingsConf.draw == 3)
	_set_visible_moves(Config.settingsConf.top_panel_moves)
	_set_visible_points(Config.settingsConf.top_panel_score)
	_set_visible_time(Config.settingsConf.top_panel_time)
	_set_holder_layout(_convert_position_to_bool(Config.settingsConf.layout))
	_set_orientation(Config.settingsConf.orientation == DisplayServer.ScreenOrientation.SCREEN_LANDSCAPE)
	_set_window_mode(Config.settingsConf.window_mode == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	
	top_panel_moves_btn.toggled.connect(_set_visible_moves)
	top_panel_score_btn.toggled.connect(_set_visible_points)
	top_panel_time_btn.toggled.connect(_set_visible_time)
	orientation_btn.toggled.connect(_set_orientation)
	window_mode_btn.toggled.connect(_set_window_mode)
	
	$CenterContainer/VBoxContainer/ScrollContainer/HBoxContainer/WindowMode.visible = !Config.mobile
	
	var buttons: Array[CheckBox] = [
		top_panel_moves_btn,
		top_panel_score_btn,
		top_panel_time_btn,
		orientation_btn,
		window_mode_btn,
	]
	for i: CheckBox in buttons:
		i.toggled.connect(func(__: bool) -> void: Config.saveSettings(self))
	


func _ready() -> void:
	
	holder_layout_btn.toggled.connect(_set_holder_layout)
	close_btn.pressed.connect(_close)
	reset_btn.pressed.connect(Config.restart)
	card_holder_max_cards_btn.toggled.connect(_set_max_cards)


func _close() -> void:
	Config.saveSettings(self)
	super()

func _set_visible_moves(state: bool) -> void:
	Config.settingsConf.top_panel_moves = state
	top_panel.set_moves_visible(state)
	
func _set_visible_points(state: bool) -> void:
	Config.settingsConf.top_panel_score = state
	top_panel.set_points_visible(state)
	
func _set_visible_time(state: bool) -> void:
	Config.settingsConf.top_panel_time = state
	top_panel.set_time_visible(state)
	

func _set_max_cards(toggled: bool) -> void:
	var amount: int
	if toggled:	
		amount = 3
	else:
		amount = 1
	card_holder.set_max_cards(amount)
	Config.settingsConf.draw = amount

func _convert_bool_to_position(state: bool) -> Positioning:
	return Positioning.RIGHT if state else Positioning.LEFT

func _convert_position_to_bool(position: Positioning) -> bool:
	return true if position == Positioning.RIGHT else false

func _convert_LAYOUT_to_positioning(layout: LayoutDirection) -> Positioning:
	return Positioning.RIGHT if layout == LAYOUT_DIRECTION_RTL else false

func _set_holder_layout(state: bool) -> void:
	holder_positioning = _convert_bool_to_position(state)
	var result: int = LAYOUT_DIRECTION_LTR if holder_positioning == Positioning.LEFT else LAYOUT_DIRECTION_RTL
	card_holder.get_parent().set_layout_direction(result)
	card_holder.set_layout_direction(result)
	Config.settingsConf.layout = holder_positioning
	
func _set_orientation(state: bool) -> void:
	if state:
		Config.set_orientation(DisplayServer.ScreenOrientation.SCREEN_LANDSCAPE)
	else:
		Config.set_orientation(DisplayServer.ScreenOrientation.SCREEN_PORTRAIT)

func _set_window_mode(state: bool) -> void:
	var mode: DisplayServer.WindowMode
	if state:
		mode = DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	else:
		mode = DisplayServer.WindowMode.WINDOW_MODE_MINIMIZED
	Config.set_window_mode(mode)
		
