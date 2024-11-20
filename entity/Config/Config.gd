class_name CONFIG
extends Node
const version: float = 1.00
var settingsConf: SettingsConf
var settings_opened: bool = false
var mobile: bool = OS.get_name() == "Android"
signal orientation_changed(orientation: DisplayServer.ScreenOrientation)

func _ready() -> void:
	_load()
	if !mobile && settingsConf.window_position && settingsConf.window_size:
		DisplayServer.window_set_size(settingsConf.window_size)
		DisplayServer.window_set_position(settingsConf.window_position)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST && !mobile:
		settingsConf.window_position = DisplayServer.window_get_position()
		settingsConf.window_size = DisplayServer.window_get_size()
		_save()

func _change_scene(open_settings: bool) -> void:
	if (
		settingsConf.orientation == DisplayServer.ScreenOrientation.SCREEN_LANDSCAPE &&
		get_tree().current_scene.scene_file_path != "res://entity/Root/HRoot_Scene.tscn"
	):
		get_tree().change_scene_to_file("res://entity/Root/HRoot_Scene.tscn")
		settings_opened = open_settings
	elif (
		settingsConf.orientation == DisplayServer.ScreenOrientation.SCREEN_PORTRAIT &&
		get_tree().current_scene.scene_file_path != "res://entity/Root/VRoot_Scene.tscn"
	):
		get_tree().change_scene_to_file("res://entity/Root/VRoot_Scene.tscn")
		settings_opened = open_settings

func set_orientation(orientation: DisplayServer.ScreenOrientation) -> void:
	DisplayServer.screen_set_orientation(orientation)
	orientation_changed.emit(orientation)
	_change_scene.call_deferred(orientation != settingsConf.orientation)
	settingsConf.orientation = orientation

func set_window_mode(mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(mode)
	Config.settingsConf.window_mode = mode

func _save() -> void:
	ResourceSaver.save(settingsConf,"user://conf.tres")

func saveSettings(settings: Settings) -> void:
	_save()

func _load() -> void:
	if FileAccess.file_exists("user://conf.tres"):
		settingsConf = ResourceLoader.load("user://conf.tres") as SettingsConf
	else:
		settingsConf = SettingsConf.new()
