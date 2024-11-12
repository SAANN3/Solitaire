class_name Bottom_Panel
extends HBoxContainer
@export var ui_parent: Control
var nodes: Array[Control]
var nodes_main: Array[Control]
var enabledNode: Control = null
@onready var settings: Settings = $Settings/Main
enum Elements {SETTINGS}

func _ready() -> void:
	nodes.assign(get_children())
	for i: Control in nodes: 
		i.gui_input.connect(func (event: InputEvent) -> void: _bottom_bar_clicked(i, event))
		if ui_parent:
			nodes_main.push_back(i.get_node("Main"))
			nodes_main[nodes.find(i)].reparent(ui_parent)
			_set_main_visible(i, false)

func close_all() -> void:
	for i: Control in nodes:
		_set_main_visible(i, false)

func get_settings() -> Settings:
	return settings

func _bottom_bar_clicked(node: Control, event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed && node.get_global_rect().has_point(event.global_position):
			_enable_node(node)

func _enable_node(node: Control) -> void:
	for i: Control in nodes:
		_set_main_visible(i, false)
	_set_main_visible(node, true)


func _set_main_visible(node: Control, visible: bool) -> void:
	nodes_main[nodes.find(node)].visible = visible

func _process(delta: float) -> void:
	pass
