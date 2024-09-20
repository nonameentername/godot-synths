@tool
extends Knob
class_name ASynthKnob

var amsynth: CsoundGodot

@export
var instrument_name: String

@export
var component_name: String

@export
var component_num: int

@export
var component_channel: String


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func update_channel():
	var control_name = "%s.%s.%d.%s" % [instrument_name, component_name, component_num, component_channel]
	var value = amsynth.get_control_channel(control_name)
	current_value = (value - min_value) / (max_value - min_value)
