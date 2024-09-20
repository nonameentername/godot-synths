class_name PianoKey
extends Control

var pitch_index: int

@onready var key: ColorRect = $Key
@onready var start_color: Color = key.color
@onready var color_timer: Timer = $ColorTimer

func setup(_pitch_index: int) -> void:
	name = "PianoKey" + str(_pitch_index)
	pitch_index = _pitch_index


func activate() -> void:
	key.color = (Color.YELLOW + start_color) / 2
	#color_timer.start()


func deactivate() -> void:
	key.color = start_color
