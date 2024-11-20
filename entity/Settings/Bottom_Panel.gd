class_name Bottom_Panel
extends HBoxContainer
@export var ui_parent: Control
var nodes: Array[Control]
var nodes_main: Array[Control]
var enabledNode: Control = null
@onready var settings: Settings = $Settings/Main
@onready var settings_hbox: VBoxContainer = $Settings
@onready var textureSettings_normal: TextureRect = $Settings/normal
@onready var textureSettings_hover: TextureRect = $Settings/hover

signal panel_change(opened: bool)

func _ready() -> void:
	if !Config.mobile:
		textureSettings_hover.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		textureSettings_normal.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		textureSettings_hover.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		textureSettings_normal.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	nodes.assign(get_children())
	settings_hbox.mouse_entered.connect(func () -> void: _on_settings_hover(true))
	settings_hbox.mouse_exited.connect(func () -> void: _on_settings_hover(false))
	for i: Control in nodes: 
		i.gui_input.connect(func (event: InputEvent) -> void: _bottom_bar_clicked(i, event))
		if ui_parent:
			nodes_main.push_back(i.get_node("Main"))
			var main_node: Base_Bottom = nodes_main[nodes.find(i)]
			main_node.closed.connect(func () -> void: panel_change.emit(false))
			main_node.reparent(ui_parent)
			_set_main_visible(i, false)
	if Config.settings_opened:
		_set_main_visible(settings_hbox, true)
		Config.settings_opened = false

func get_settings() -> Settings:
	return settings

func _bottom_bar_clicked(node: Control, event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_released() && node.get_global_rect().has_point(event.global_position):
			_set_main_visible(node, true)
			panel_change.emit(true)

func _set_main_visible(node: Control, visible: bool) -> void:
	nodes_main[nodes.find(node)].visible = visible

func _on_settings_hover(inside: bool) -> void:
	if inside:
		textureSettings_normal.visible = false
		textureSettings_hover.visible = true
	else:
		textureSettings_normal.visible = true
		textureSettings_hover.visible = false
		
	
func _process(delta: float) -> void:
	pass
