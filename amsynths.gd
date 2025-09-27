extends Node2D

@export
var use_jack: bool = false

var amsynth: Dictionary = {}


func _ready() -> void:
	if OS.has_feature("web"):
		CsoundServer.open_web_midi_inputs()
	elif "JackServer" in Engine.get_singleton_list() and use_jack:
		Engine.get_singleton("JackServer").open_midi_inputs("godot-synths", 1, 0)
	else:
		OS.open_midi_inputs()
		print(OS.get_connected_midi_inputs())

	CsoundServer.connect("csound_ready", csound_ready)


func csound_ready(csound_name: String) -> void:
	if csound_name == "Main":
		return

	var csound_instance: CsoundInstance = CsoundServer.get_csound(csound_name)
	var channel: int = int(csound_instance.evaluate_code("return $INSTRUMENT_CHANNEL"))
	#TODO: get channels as a list instead of this
	amsynth[channel - 1] = csound_instance
	amsynth[channel] = csound_instance


func _input(input_event):
	if input_event is InputEventMIDI:
		_send_midi_info(input_event)


func _send_midi_info(midi_event):
	#print(midi_event)
	#print("Channel ", midi_event.channel)
	#print("Message ", midi_event.message)
	#print("Pitch ", midi_event.pitch)
	#print("Velocity ", midi_event.velocity)
	#print("Instrument ", midi_event.instrument)
	#print("Pressure ", midi_event.pressure)
	#print("Controller number: ", midi_event.controller_number)
	#print("Controller value: ", midi_event.controller_value)
	#print("")

	var midi_index = midi_event.channel + 1

	if midi_index in amsynth:
		if midi_event.message == MIDI_MESSAGE_NOTE_ON:
			amsynth[midi_index].note_on(midi_event.channel, midi_event.pitch, midi_event.velocity)
		if midi_event.message == MIDI_MESSAGE_NOTE_OFF:
			amsynth[midi_index].note_off(midi_event.channel, midi_event.pitch)
		if midi_event.message == MIDI_MESSAGE_CONTROL_CHANGE:
			amsynth[midi_index].control_change(midi_event.channel, midi_event.controller_number, midi_event.controller_value)
