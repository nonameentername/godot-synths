extends Node2D
class_name ASynth

@export
var instrument_name: String

var amsynth: CsoundGodot

var oscillator_1: ASynthKnob
var oscillator_2: ASynthKnob
var lfo_1: ASynthKnob
var oscillator_1_waveform: Waveform
var oscillator_2_waveform: Waveform
var lfo_1_waveform: Waveform

func _ready():
	CsoundServer.csound_layout_changed.connect(csound_layout_changed)

	oscillator_1 = $Oscillator1/Oscillator1Waveform
	oscillator_2 = $Oscillator2/Oscillator2Waveform
	lfo_1 = $Lfo/LfoWaveform

	oscillator_1_waveform = $Oscillator1/waveform
	oscillator_2_waveform = $Oscillator2/waveform
	lfo_1_waveform = $Lfo/waveform


func csound_layout_changed():
	amsynth = CsoundServer.get_csound("amsynth")
	amsynth.csound_ready.connect(initialize)

	for child_panel in get_children():
		for node in child_panel.get_children():
			if node is ASynthKnob:
				node.instrument_name = instrument_name
				node.amsynth = amsynth


func initialize() -> void:
	var instrument = """
<CsoundSynthesizer>
<CsInstruments>

instr {name}
	SInstrName = "{name}"
	SInstrMixer = "{name}_mixer"
	aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6
	ASynthMixerSend SInstrName, SInstrMixer, aSendL, aSendR
endin

instr {name}_midi
	SInstrName = "{name}"
	iChannel = p4
	iMidiKey = p5
	iMidiVelocity = p6
	ASynthInput SInstrName, iChannel, iMidiKey, iMidiVelocity
endin

instr {name}_mixer
	SInstrName = "{name}"
	SInstrMixer = "{name}_mixer"
	ASynthEffects SInstrName, SInstrMixer
endin



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

</CsInstruments>
<CsScore>
i "{name}_mixer" 0 -1
</CsScore>
</CsoundSynthesizer>

""".format({"name": instrument_name})
	amsynth.compile_orchestra(instrument)

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
	print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_lfo_oscillator_2_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfoFreq", 2, "freq_mod_amount"]
	print(control_name, value)
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
	amsynth.compile_orchestra(load_preset)

	update_knobs()
	update_waveforms()


func update_waveforms():
	oscillator_1_waveform.waveform = int(oscillator_1.actual_value)
	oscillator_2_waveform.waveform = int(oscillator_2.actual_value)
	lfo_1_waveform.waveform = int(lfo_1.actual_value)
