class_name Base_Bottom
extends Control

signal closed()

func _close() -> void:
	closed.emit()
	self.visible = false
