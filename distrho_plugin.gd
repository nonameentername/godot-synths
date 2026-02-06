extends Node2D


func _ready() -> void:
	print(
		"godot-distrho version: ",
		DistrhoPluginServer.get_version(),
		" build: ",
		DistrhoPluginServer.get_build()
	)

	#DistrhoPluginServer.midi_event.connect(_on_midi_event)
	DistrhoPluginServer.midi_note_on.connect(_on_midi_note_on)
	DistrhoPluginServer.midi_note_off.connect(_on_midi_note_off)


func _on_midi_event(midi_event: DistrhoMidiEvent) -> void:
	print(
		"MIDI Event: channel: ",
		midi_event.channel,
		" status: ",
		midi_event.status,
		" data1: ",
		midi_event.data1,
		" data2: ",
		midi_event.data2,
		" frame: ",
		midi_event.frame
	)


func _on_midi_note_on(channel: int, note: int, velocity: int, frame: int) -> void:
	print(
		"Note On: channel: ", channel, " note: ", note, " velocity: ", velocity, " frame: ", frame
	)

	var input_event_midi: InputEventMIDI = InputEventMIDI.new()
	input_event_midi.device = 0
	input_event_midi.channel = channel
	input_event_midi.message = MIDI_MESSAGE_NOTE_ON
	input_event_midi.pitch = note
	input_event_midi.velocity = velocity

	Input.parse_input_event(input_event_midi)


func _on_midi_note_off(channel: int, note: int, velocity: int, frame: int) -> void:
	print(
		"Note Off: channel: ", channel, " note: ", note, " velocity: ", velocity, " frame: ", frame
	)

	var input_event_midi: InputEventMIDI = InputEventMIDI.new()
	input_event_midi.device = 0
	input_event_midi.channel = channel
	input_event_midi.message = MIDI_MESSAGE_NOTE_OFF
	input_event_midi.pitch = note
	input_event_midi.velocity = velocity

	Input.parse_input_event(input_event_midi)
