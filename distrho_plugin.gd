extends Node2D


const VU_COUNT = 16
const FREQ_MAX = 11050.0
const MIN_DB = 60


@onready
var amsynth = $amsynths
var spectrum: AudioEffectSpectrumAnalyzerInstance


func _ready() -> void:
	print(
		"godot-distrho version: ",
		DistrhoPluginServer.get_version(),
		" build: ",
		DistrhoPluginServer.get_build()
	)

	spectrum = AudioServer.get_bus_effect_instance(0, 0)

	#DistrhoPluginServer.midi_event.connect(_on_midi_event)
	DistrhoPluginServer.midi_note_on.connect(_on_midi_note_on)
	DistrhoPluginServer.midi_note_off.connect(_on_midi_note_off)
	DistrhoPluginServer.parameter_changed.connect(amsynth._on_amsynth_parameter_changed)


func _process(_delta: float) -> void:
	var prev_hz := 0.0

	for i in range(0, VU_COUNT):
		var hz := i * FREQ_MAX / VU_COUNT
		var magnitude := spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy := clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		prev_hz = hz

		var first_parameter = 42
		DistrhoPluginServer.set_parameter_value(first_parameter + i, energy)


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
	DistrhoPluginServer.update_state_value.call_deferred(str(note), "true")


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
	DistrhoPluginServer.update_state_value.call_deferred(str(note), "false")
