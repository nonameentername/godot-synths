@tool
extends Control
class_name ASynth

var csound_name: String

@export
var instrument_name: String

@export
var instrument_channel: int

var amsynth: CsoundGodot

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

	properties.append({
		"name": "csound_name",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": CsoundServer.get_csound_name_options(),
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
	CsoundServer.csound_layout_changed.connect(csound_layout_changed)

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


func csound_layout_changed():
	amsynth = CsoundServer.get_csound(csound_name)
	amsynth.csound_ready.connect(initialize)

	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				node.instrument_name = instrument_name
				node.amsynth = amsynth


func initialize(csound_name: String) -> void:
	var instrument = """
<CsoundSynthesizer>
<CsInstruments>

instr {name}
	SInstrName = "{name}"
	SInstrMixer = "{name}_mixer"
	aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6
	print p1, p2, p3, p4, p5, p6
	ASynthMixerSend SInstrName, SInstrMixer, aSendL, aSendR
endin

instr {name}_midi
	SInstrName = "{name}"
	;iChannel = p4
	iChannel midichn
	iMidiKey = p5
	iMidiVelocity = p6
	print p1, p2, p3, p4, p5, p6
	ASynthInput SInstrName, iChannel, iMidiKey, iMidiVelocity
endin

instr {name}_mixer
	SInstrName = "{name}"
	SInstrMixer = "{name}_mixer"
	ASynthEffects SInstrName, SInstrMixer
endin

maxalloc "{name}", 8, 1


DefineChannel "{name}", "ASynthAmp", 1, "amp_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0750000029802322, 0, 2.5
DefineChannel "{name}", "ASynthAmp", 1, "amp_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1.55833005905151, 0, 2.5
DefineChannel "{name}", "ASynthAmp", 1, "amp_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1.0
DefineChannel "{name}", "ASynthAmp", 1, "amp_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.706920027732849, 0, 2.5
DefineChannel "{name}", "ASynthOsc", 1, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "{name}", "ASynthFilter", 1, "filter_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.133332997560501, 0, 2.5
DefineChannel "{name}", "ASynthFilter", 1, "filter_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.166666999459267, 0, 2.5
DefineChannel "{name}", "ASynthFilter", 1, "filter_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0966669991612434, 0, 1.0
DefineChannel "{name}", "ASynthFilter", 1, "filter_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.86666601896286, 0, 2.5
DefineChannel "{name}", "ASynthFilter", 1, "filter_resonance", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.036062997579575, 0, 0.97
DefineChannel "{name}", "ASynthFilter", 1, "filter_env_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1.13385999202728, -16, 16
DefineChannel "{name}", "ASynthFilter", 1, "filter_cutoff", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.106298997998238, -0.5, 1.5
DefineChannel "{name}", "ASynthDetune", 2, "osc_detune", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.22834600508213, -1, 1
DefineChannel "{name}", "ASynthOsc", 2, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "{name}", "ASynthRender", 1, "master_vol", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.692900002002716, 0, 1
DefineChannel "{name}", "ASynthLfo", 1, "lfo_freq", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0, 0, 7.5
DefineChannel "{name}", "ASynthLfo", 1, "lfo_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 6.0
DefineChannel "{name}", "ASynthDetune", 2, "osc_range", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, -3, 4
DefineChannel "{name}", "ASynthMix", 1, "osc_mix", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.244093999266624, -1, 1
DefineChannel "{name}", "ASynthLfoFreq", 1, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "{name}", "ASynthLfoFreq", 2, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "{name}", "ASynthFilter", 1, "filter_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -1, -1, 1
DefineChannel "{name}", "ASynthAmp", 1, "amp_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -1, -1, 1
DefineChannel "{name}", "ASynthMix", 1, "osc_mix_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "{name}", "ASynthOsc", 1, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.629921019077301, 0, 1.0
DefineChannel "{name}", "ASynthOsc", 2, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.173227995634079, 0, 1.0
DefineChannel "{name}", "ASynthReverb", 1, "reverb_roomsize", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.206667006015778, 0, 1
DefineChannel "{name}", "ASynthReverb", 1, "reverb_damp", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "{name}", "ASynthReverb", 1, "reverb_wet", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0799999982118607, 0, 1
DefineChannel "{name}", "ASynthReverb", 1, "reverb_width", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1
DefineChannel "{name}", "ASynthOverDrive", 1, "distortion_crunch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 0.9
DefineChannel "{name}", "ASynthOsc", 1, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
DefineChannel "{name}", "ASynthOsc", 2, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
DefineChannel "{name}", "ASynthInput", 1, "portamento_time", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0133330002427101, 0, 1
DefineChannel "{name}", "ASynthInput", 1, "keyboard_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2
DefineChannel "{name}", "ASynthDetune", 2, "osc_pitch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, -1, -12, 12
DefineChannel "{name}", "ASynthFilter", 1, "filter_type", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 4.0
DefineChannel "{name}", "ASynthLfoFreq", 1, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "{name}", "ASynthLfoFreq", 2, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "{name}", "ASynthFilter", 1, "filter_kbd_track", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.783333003520966, 0, 1
DefineChannel "{name}", "ASynthInput", 1, "portamento_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1

massign {channel}, "{name}_midi"

</CsInstruments>
<CsScore>
i "{name}_mixer" 0 -1
</CsScore>
</CsoundSynthesizer>

""".format({"name": instrument_name, "channel": instrument_channel})
	amsynth.compile_csd(instrument)

	update_knobs()
	update_waveforms()


func update_knobs():
	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				node.update_channel()


func _process(_delta: float) -> void:
	pass


func _on_oscillator_1_waveform_value_changed(value: float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 1, "osc_waveform"]
	amsynth.send_control_channel(control_name, value)
	oscillator_1_waveform.waveform = int(value)


func _on_oscillator_1_shape_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 1, "osc_pulsewidth"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_1_detune_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 1, "osc_detune"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_1_semitone_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 1, "osc_pitch"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_1_octave_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 1, "osc_range"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_waveform_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 2, "osc_waveform"]
	amsynth.send_control_channel(control_name, value)
	oscillator_2_waveform.waveform = int(value)


func _on_oscillator_2_shape_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 2, "osc_pulsewidth"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_detune_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 2, "osc_detune"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_semitone_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 2, "osc_pitch"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_octave_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 2, "osc_range"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_mix_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthMix", 1, "osc_mix"]
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_mix_mode_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthMix", 1, "osc_mix_mode"]
	amsynth.send_control_channel(control_name, value)


func _on_amp_attack_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_attack"]
	amsynth.send_control_channel(control_name, value)


func _on_amp_decay_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_decay"]
	amsynth.send_control_channel(control_name, value)


func _on_amp_sustain_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_sustain"]
	amsynth.send_control_channel(control_name, value)
	

func _on_amp_release_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_release"]
	amsynth.send_control_channel(control_name, value)


func _on_lfo_waveform_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfo", 1, "lfo_waveform"]
	amsynth.send_control_channel(control_name, value)
	lfo_1_waveform.waveform = int(value)


func _on_lfo_speed_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfo", 1, "lfo_freq"]
	amsynth.send_control_channel(control_name, value)


func _on_lfo_oscillator_1_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfoFreq", 1, "freq_mod_amount"]
	amsynth.send_control_channel(control_name, value)


func _on_lfo_oscillator_2_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfoFreq", 2, "freq_mod_amount"]
	amsynth.send_control_channel(control_name, value)


func _on_lfo_filter_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_mod_amount"]
	amsynth.send_control_channel(control_name, value)


func _on_lfo_amp_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_mod_amount"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_type"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_resonance_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_resonance"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_cutoff_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_cutoff"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_key_track_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_kbd_track"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_envelope_amount_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_env_amount"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_attack_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_attack"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_decay_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_decay"]
	amsynth.send_control_channel(control_name, value)


func _on_filter_sustain_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_sustain"]
	amsynth.send_control_channel(control_name, value)

func _on_filter_release_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_release"]
	amsynth.send_control_channel(control_name, value)


func _on_amp_volume_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthRender", 1, "master_vol"]
	amsynth.send_control_channel(control_name, value)


func _on_amp_drive_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOverDrive", 1, "distortion_crunch"]
	amsynth.send_control_channel(control_name, value)


func _on_reverb_amount_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_wet"]
	amsynth.send_control_channel(control_name, value)


func _on_reverb_size_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_roomsize"]
	amsynth.send_control_channel(control_name, value)


func _on_reverb_stereo_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_width"]
	amsynth.send_control_channel(control_name, value)


func _on_reverb_damping_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_damp"]
	amsynth.send_control_channel(control_name, value)


func _on_portamento_time_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthInput", 1, "portamento_time"]
	amsynth.send_control_channel(control_name, value)


func _on_portamento_mode_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthInput", 1, "portamento_mode"]
	amsynth.send_control_channel(control_name, value)


func _on_portamento_keyboard_mode_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthInput", 1, "keyboard_mode"]
	amsynth.send_control_channel(control_name, value)


func _on_presets_load_preset(preset:String) -> void:
	var load_preset = """
<CsoundSynthesizer>
<CsInstruments>

#define INSTRUMENT_NAME #{name}#
#include "{preset}"

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>

""".format({"name": instrument_name, "preset": preset})
	amsynth.compile_csd(load_preset)

	update_knobs()
	update_waveforms()


func update_waveforms():
	oscillator_1_waveform.waveform = int(oscillator_1.actual_value)
	oscillator_2_waveform.waveform = int(oscillator_2.actual_value)
	lfo_1_waveform.waveform = int(lfo_1.actual_value)


func save_knobs_values():
	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				node.update_channel()


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

	for name in saved_preset:
		var value = saved_preset[name]
		amsynth.send_control_channel("%s.%s" % [instrument_name, name], value)

		update_knobs()


func _on_button_save_pressed() -> void:
	if saved_preset_name.text == "":
		return

	var saved_preset = {}

	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				var name = node.get_control_channel_name()
				var value = node.get_control_channel_value()
				saved_preset[name] = value

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
