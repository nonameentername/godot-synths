extends Node2D

@export
var use_jack: bool = false

var amsynth: CsoundGodot
var initialized: bool = false

var forward_midi: Dictionary =  {}

@onready
var tab_container: TabContainer = $"TabContainer"


func _ready() -> void:
	if OS.has_feature("web"):
		CsoundServer.open_web_midi_inputs()
	elif "JackServer" in Engine.get_singleton_list() and use_jack:
		Engine.get_singleton("JackServer").open_midi_inputs("godot-synths", 1, 0)
	else:
		OS.open_midi_inputs()
		print(OS.get_connected_midi_inputs())

	CsoundServer.csound_layout_changed.connect(csound_layout_changed)

	for index in range(1, 16):
		forward_midi[index] = false


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

	var should_forward_midi: bool = false
	for channel in forward_midi:
		should_forward_midi = should_forward_midi or forward_midi[channel]

	if should_forward_midi:
		for channel in forward_midi:
			if forward_midi[channel]:
				if midi_event.message == MIDI_MESSAGE_NOTE_ON:
					amsynth.note_on(channel, midi_event.pitch, midi_event.velocity)
				if midi_event.message == MIDI_MESSAGE_NOTE_OFF:
					amsynth.note_off(channel, midi_event.pitch)
	else:
		if midi_event.message == MIDI_MESSAGE_NOTE_ON:
			amsynth.note_on(midi_event.channel, midi_event.pitch, midi_event.velocity)
		if midi_event.message == MIDI_MESSAGE_NOTE_OFF:
			amsynth.note_off(midi_event.channel, midi_event.pitch)


func _on_check_box_1_toggled(toggled_on:bool) -> void:
	forward_midi[1] = toggled_on
	if toggled_on:
		tab_container.current_tab = 0


func _on_check_box_2_toggled(toggled_on:bool) -> void:
	forward_midi[2] = toggled_on
	if toggled_on:
		tab_container.current_tab = 1


func _on_check_box_3_toggled(toggled_on:bool) -> void:
	forward_midi[3] = toggled_on
	if toggled_on:
		tab_container.current_tab = 2


func _on_check_box_4_toggled(toggled_on:bool) -> void:
	forward_midi[4] = toggled_on
	if toggled_on:
		tab_container.current_tab = 3


func _on_check_box_5_toggled(toggled_on:bool) -> void:
	forward_midi[5] = toggled_on
	if toggled_on:
		tab_container.current_tab = 4


func _on_check_box_6_toggled(toggled_on:bool) -> void:
	forward_midi[6] = toggled_on
	if toggled_on:
		tab_container.current_tab = 5


func _on_check_box_7_toggled(toggled_on:bool) -> void:
	forward_midi[7] = toggled_on
	if toggled_on:
		tab_container.current_tab = 6


func _on_check_box_8_toggled(toggled_on:bool) -> void:
	forward_midi[8] = toggled_on
	if toggled_on:
		tab_container.current_tab = 7


func _on_check_box_9_toggled(toggled_on:bool) -> void:
	forward_midi[9] = toggled_on
	if toggled_on:
		tab_container.current_tab = 8


func _on_check_box_10_toggled(toggled_on:bool) -> void:
	forward_midi[10] = toggled_on
	if toggled_on:
		tab_container.current_tab = 9


func _on_check_box_11_toggled(toggled_on:bool) -> void:
	forward_midi[11] = toggled_on
	if toggled_on:
		tab_container.current_tab = 10


func _on_check_box_12_toggled(toggled_on:bool) -> void:
	forward_midi[12] = toggled_on
	if toggled_on:
		tab_container.current_tab = 11


func _on_check_box_13_toggled(toggled_on:bool) -> void:
	forward_midi[13] = toggled_on
	if toggled_on:
		tab_container.current_tab = 12


func _on_check_box_14_toggled(toggled_on:bool) -> void:
	forward_midi[14] = toggled_on
	if toggled_on:
		tab_container.current_tab = 13


func _on_check_box_15_toggled(toggled_on:bool) -> void:
	forward_midi[15] = toggled_on
	if toggled_on:
		tab_container.current_tab = 14


func _on_check_box_16_toggled(toggled_on:bool) -> void:
	forward_midi[16] = toggled_on
	if toggled_on:
		tab_container.current_tab = 15
