extends Node2D

var amsynth: CsoundGodot
var initialized: bool = false


func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	CsoundServer.csound_layout_changed.connect(csound_layout_changed)

func csound_layout_changed():
	amsynth = CsoundServer.get_csound("amsynth")
	amsynth.csound_ready.connect(initialize)

func initialize() -> void:
	initialized = true


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

	if midi_event.message == MIDI_MESSAGE_NOTE_ON:
		amsynth.instrument_note_on("one_midi", 1, midi_event.pitch, midi_event.velocity)

	if midi_event.message == MIDI_MESSAGE_NOTE_ON:
		amsynth.instrument_note_off("one_midi", 1, midi_event.pitch)


func _process(_delta: float) -> void:
	pass
