class_name CONFIG
extends Node
const version: float = 1.00
var settingsConf: Dictionary = {
	"version": "float",
	"layout": "int",
	"top_panel": {
		"score": "bool",
		"time": "bool",
		"moves": "bool",
	},
	"draw": "int",
}
var loaded: bool

func _ready() -> void:
	loaded = _load()

func _save() -> void:
	var file: FileAccess = FileAccess.open("user://conf.save", FileAccess.WRITE)
	file.store_line(JSON.stringify(settingsConf))

func saveSettings(settings: Settings) -> void:
	settingsConf["layout"] = settings.holder_positioning
	settingsConf["top_panel"]["score"] = settings.top_panel_visible_points
	settingsConf["top_panel"]["time"] = settings.top_panel_visible_time
	settingsConf["top_panel"]["moves"] = settings.top_panel_visible_moves
	settingsConf["draw"] = settings.card_holder_max_cards
	settingsConf["version"] = version
	_save()

func _load() -> bool:
	var file: FileAccess = FileAccess.open("user://conf.save", FileAccess.READ)
	if !file:
		return false
	if file.get_position() < file.get_length():
		var result: Dictionary = JSON.new().parse_string(file.get_line())
		settingsConf = result
		print(settingsConf)
	return true
