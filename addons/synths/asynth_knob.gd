@tool
extends BaseKnob
class_name ASynthKnob

var amsynth: CsoundInstance

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


func get_control_channel_name() -> String:
	return "%s.%d.%s" % [component_name, component_num, component_channel]


func get_control_channel_value() -> float:
	var control_name = "%s.%s.%d.%s" % [instrument_name, component_name, component_num, component_channel]
	return amsynth.get_control_channel(control_name)


func set_control_channel_value(value: float):
	var control_name = "%s.%s.%d.%s" % [instrument_name, component_name, component_num, component_channel]
	amsynth.send_control_channel(control_name, value)


func update_channel():
	var value = get_control_channel_value()
	current_value = (value - min_value) / (max_value - min_value)
