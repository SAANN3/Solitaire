class_name Top_Panel
extends Container

@onready var points_label: Label = $points
@onready var time_label: Label = $time
@onready var moves_label: Label = $moves
@onready var spacer_1: Control = $space
@onready var spacer_2: Control = $space2

func _ready() -> void:
	pass # Replace with function body.
	

func set_points(points: int) -> void:
	points_label.text = "score : " + str(points)	

func set_moves(moves: int) -> void:
	moves_label.text = "moves : " + str(moves)

func set_time(seconds_passed: int) -> void:
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

func set_points_visible(visible: bool) -> void:
	points_label.visible = visible
	_set_spacers()

func set_time_visible(visible: bool) -> void:
	time_label.visible = visible
	_set_spacers()
	
func set_moves_visible(visible: bool) -> void:
	moves_label.visible = visible
	_set_spacers()

func _set_spacers() -> void:
	#UGLY 
	var visible_count: int = 0
	visible_count += moves_label.visible as int
	visible_count += points_label.visible as int
	visible_count += time_label.visible as int
	if visible_count == 3:
		spacer_1.visible = true
		spacer_2.visible = true
	elif visible_count == 2:
		if moves_label.visible:
			spacer_2.visible = true
			spacer_1.visible = false
		if points_label.visible:
			spacer_1.visible = true
			spacer_2.visible = false
	elif visible_count == 1:
		spacer_1.visible = false
		spacer_2.visible = false

func is_moves_visible() -> bool:
	return moves_label.visible
	
func is_time_visible() -> bool:
	return time_label.visible

func is_points_visible() -> bool:
	return points_label.visible
