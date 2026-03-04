extends Node2D


@onready
var piano = $amsynths_ui/Panel/Piano

@onready
var spectrum = $amsynths_ui/ShowSpectrum


func _ready() -> void:
	print(
		"godot-distrho version: ",
		DistrhoPluginServer.get_version(),
		" build: ",
		DistrhoPluginServer.get_build()
	)
	DistrhoUIServer.parameter_changed.connect(_on_parameter_changed)
	DistrhoUIServer.state_changed.connect(_on_state_changed)


func _input(input_event: InputEvent) -> void:
	if input_event is InputEventMIDI:
		var midi_event: InputEventMIDI = input_event
		if midi_event.message == MIDI_MESSAGE_NOTE_ON:
			DistrhoUIServer.send_note_on(midi_event.channel, midi_event.pitch, midi_event.velocity)
		if midi_event.message == MIDI_MESSAGE_NOTE_OFF:
			DistrhoUIServer.send_note_off(midi_event.channel, midi_event.pitch)
		if midi_event.message == MIDI_MESSAGE_CONTROL_CHANGE:
			print ("channel = ", midi_event.channel, 
				   " controller = ", midi_event.controller_number,
				   " value = ",  midi_event.controller_value)


func _on_parameter_changed(index: int, value: float) -> void:
	var first_parameter = 42

	if index < first_parameter:
		print("UI: Parameter Changed: index: ", index, " value: ", value)
	else:
		spectrum.energy_values[index - first_parameter] = value


func _on_state_changed(key: String, value: String) -> void:
	print("UI: State Changed: index: ", key, " value: ", value)
	piano.update_key(int(key), value == "true")


func _on_amsynth_parameter_changed(parameter: int, value: float) -> void:
	print ("parameter ", parameter, " value = ", value)
	DistrhoUIServer.set_parameter_value(parameter, value)
