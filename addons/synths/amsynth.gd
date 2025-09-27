@tool
extends Control
class_name ASynth

var csound_name: String

@export
var instrument_name: String

@export
var instrument_channel: int


var oscillator_1: ASynthKnob
var oscillator_2: ASynthKnob
var lfo_1: ASynthKnob
var oscillator_1_waveform: Waveform
var oscillator_2_waveform: Waveform
var lfo_1_waveform: Waveform

var saved_preset_name: LineEdit
var saved_preset_item_list: ItemList
var save_button: Button

var presets: Array[String] = []

func _get_property_list():
	var properties = []

	var csound_names: String

	if Engine.is_editor_hint():
		csound_names = CsoundServer.get_csound_name_options()

	properties.append({
		"name": "csound_name",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": csound_names,
	})

	return properties

func _get(property):
	if property == "csound_name":
		return csound_name

func _set(property, value):
	if property == "csound_name":
		csound_name = value
		return true
	return false


func _ready():
	oscillator_1 = $Oscillator1/Oscillator1Waveform
	oscillator_2 = $Oscillator2/Oscillator2Waveform
	lfo_1 = $Lfo/LfoWaveform

	oscillator_1_waveform = $Oscillator1/waveform
	oscillator_2_waveform = $Oscillator2/waveform
	lfo_1_waveform = $Lfo/waveform

	saved_preset_name = $TabContainer/SavedPresets/LineEdit
	saved_preset_item_list = $TabContainer/SavedPresets/ItemList
	save_button = $TabContainer/SavedPresets/ButtonSave

	load_saved_presets()
	update_saved_presets("")


func update_knobs(content: Dictionary):
	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				node.current_value = content[str(node.control)]


func _process(_delta: float) -> void:
	pass


func _send_midi_cc(control: int, value: float) -> void:
	var input_event_midi: InputEventMIDI = InputEventMIDI.new()
	input_event_midi.device = 0
	input_event_midi.channel = instrument_channel - 1
	input_event_midi.message = MIDI_MESSAGE_CONTROL_CHANGE
	input_event_midi.controller_number = control
	input_event_midi.controller_value = value * 127

	Input.parse_input_event(input_event_midi)


func _on_oscillator_1_waveform_value_changed(control: int, value: float, actual_value: float) -> void:
	_send_midi_cc(control, value)
	oscillator_1_waveform.waveform = actual_value


func _on_oscillator_1_shape_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_1_octave_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_1_semitone_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_1_detune_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_2_waveform_value_changed(control: int, value:float, actual_value: float) -> void:
	_send_midi_cc(control, value)
	oscillator_2_waveform.waveform = actual_value


func _on_oscillator_2_shape_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_2_octave_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_2_semitone_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_2_detune_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_mix_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_oscillator_mix_mode_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_amp_attack_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_amp_decay_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_amp_sustain_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)
	

func _on_amp_release_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_amp_volume_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_amp_drive_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_resonance_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_cutoff_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_key_track_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_envelope_amount_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_attack_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_decay_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_sustain_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_filter_release_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_portamento_time_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_portamento_mode_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_portamento_keyboard_mode_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_lfo_waveform_value_changed(control: int, value:float, actual_value: float) -> void:
	_send_midi_cc(control, value)
	lfo_1_waveform.waveform = actual_value


func _on_lfo_speed_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_lfo_oscillator_1_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_lfo_oscillator_2_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_lfo_filter_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_lfo_amp_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_reverb_amount_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_reverb_size_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_reverb_stereo_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func _on_reverb_damping_value_changed(control: int, value:float, _actual_value: float) -> void:
	_send_midi_cc(control, value)


func load_preset(preset:String) -> void:
	var file = FileAccess.open(preset, FileAccess.READ)
	var json_content = file.get_as_text()
	file.close()

	var content = JSON.parse_string(json_content)

	for control in content:
		var value = content[control]
		_send_midi_cc(int(control), value)

	update_knobs(content)
	update_waveforms()


func _on_presets_load_preset(preset:String) -> void:
	load_preset(preset)


func update_waveforms():
	oscillator_1_waveform.waveform = int(oscillator_1.actual_value)
	oscillator_2_waveform.waveform = int(oscillator_2.actual_value)
	lfo_1_waveform.waveform = int(lfo_1.actual_value)


func load_saved_presets():
	presets.clear()

	if not DirAccess.dir_exists_absolute("user://presets"):
		DirAccess.make_dir_absolute("user://presets")
	for file_name in DirAccess.get_files_at("user://presets"):
		presets.append(file_name)


func update_saved_presets(text: String):
	saved_preset_item_list.clear()

	for preset in presets:
		if preset.to_lower().contains(text.to_lower()) or len(text) == 0:
			var index = saved_preset_item_list.add_item(preset)
			saved_preset_item_list.set_item_text(index, preset)


func _on_button_load_pressed() -> void:
	if len(saved_preset_item_list.get_selected_items()) == 0:
		return

	var index: int = saved_preset_item_list.get_selected_items()[0]
	var selected_item_text = saved_preset_item_list.get_item_text(index)

	var load_file = FileAccess.open("user://presets/%s" % (selected_item_text), FileAccess.READ)
	var json_string = load_file.get_line()
	var saved_preset = JSON.parse_string(json_string)

	for control in saved_preset:
		var value = saved_preset[control]
		_send_midi_cc(int(control), value)

	update_knobs(saved_preset)
	update_waveforms()


func _on_button_save_pressed() -> void:
	if saved_preset_name.text == "":
		return

	var saved_preset = {}

	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				var control = node.control
				var value = node.current_value
				saved_preset[control] = value

	#TODO: add sync to ui
	saved_preset["3"] = 0
	saved_preset["9"] = 0

	var json_string = JSON.stringify(saved_preset)

	var save_file = FileAccess.open("user://presets/%s" % (saved_preset_name.text), FileAccess.WRITE)
	save_file.store_line(json_string)
	save_file.close()

	if not saved_preset_name.text in presets:
		presets.append(saved_preset_name.text)

	saved_preset_name.text = ""

	update_saved_presets(saved_preset_name.text)


func _on_line_edit_text_changed(new_text:String) -> void:
	update_saved_presets(new_text)
	save_button.disabled = len(new_text) == 0
