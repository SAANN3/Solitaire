@tool
class_name CheckBoxFixed
extends CheckBox
@onready var checked: TextureRect = $checked
@onready var unchecked: TextureRect = $unchecked
@export var checked_texture: Texture2D:
	set(texture):
		checked_texture = texture
		if checked:
			checked.texture = texture
		else:
			await ready
			checked.texture = texture
			
@export var unchecked_texture: Texture2D:
	set(texture):
		unchecked_texture = texture
		if unchecked:
			unchecked.texture = texture
		else:
			await ready
			unchecked.texture = texture

func _ready() -> void:
	toggled.connect(pressed)
	if Config.mobile:
		set_custom_minimum_size(Vector2(240,240))
	else:
		set_custom_minimum_size(Vector2(60,60))
func pressed(state: bool) -> void:
	if state:
		checked.visible = true
		unchecked.visible = false
	else:
		unchecked.visible = true
		checked.visible = false
		
