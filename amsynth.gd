extends Node2D

@export
var instrument_name: String

var amsynth: CsoundGodot

var oscillator_1_waveform: Waveform
var oscillator_2_waveform: Waveform
var lfo_1_waveform: Waveform

func _ready():
	CsoundServer.csound_layout_changed.connect(csound_layout_changed)
	oscillator_1_waveform = $Oscillator1/waveform
	oscillator_2_waveform = $Oscillator2/waveform
	lfo_1_waveform = $Lfo/waveform


func csound_layout_changed():
	amsynth = CsoundServer.get_csound("amsynth")
	amsynth.csound_ready.connect(initialize)


func initialize() -> void:
	var instrument = """
<CsoundSynthesizer>
<CsInstruments>

instr {name}
	SInstrName = "{name}"
	SInstrMixer = "{name}_mixer"
	iChannel = 3
	aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6, iChannel
	ASynthMixerSend SInstrName, SInstrMixer, aSendL, aSendR
endin

instr {name}_midi
	SInstrName = "{name}"
	iChannel = 1
	iMidiKey = p4
	iMidiVelocity = p5
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
	#amsynth.input_message('i "{name}_mixer" 0 -1'.format({"name": instrument_name}))


func _process(_delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on:bool) -> void:
	if toggled_on:
		amsynth.instrument_note_on("{name}_midi".format({"name": instrument_name}), 1, 60, 90)
	else:
		amsynth.instrument_note_off("{name}_midi".format({"name": instrument_name}), 1, 60)




func _on_oscillator_1_waveform_value_changed(value: float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 1, "osc_waveform"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)
	oscillator_1_waveform.waveform = int(value)


func _on_oscillator_1_shape_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 1, "osc_pulsewidth"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_1_detune_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 1, "osc_detune"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_1_semitone_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 1, "osc_pitch"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_1_octave_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 1, "osc_range"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_waveform_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 2, "osc_waveform"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)
	oscillator_2_waveform.waveform = int(value)


func _on_oscillator_2_shape_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOsc", 2, "osc_pulsewidth"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_detune_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 2, "osc_detune"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_semitone_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 2, "osc_pitch"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_2_octave_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthDetune", 2, "osc_range"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_mix_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthMix", 1, "osc_mix"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_oscillator_mix_mode_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthMix", 1, "osc_mix_mode"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)



func _on_amp_attack_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_attack"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_amp_decay_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_decay"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_amp_sustain_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_sustain"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)
	

func _on_amp_release_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_release"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)



func _on_lfo_waveform_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfo", 1, "lfo_waveform"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)
	lfo_1_waveform.waveform = int(value)


func _on_lfo_speed_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthLfo", 1, "lfo_freq"]
	#print(control_name, value)
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
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_lfo_amp_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthAmp", 1, "amp_mod_amount"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_type"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_resonance_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_resonance"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_cutoff_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_cutoff"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_key_track_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_kbd_track"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_envelope_amount_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_env_amount"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_attack_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_attack"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_decay_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_decay"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_filter_sustain_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_sustain"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)

func _on_filter_release_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthFilter", 1, "filter_release"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_amp_volume_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthRender", 1, "master_vol"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_amp_drive_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthOverDrive", 1, "distortion_crunch"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_reverb_amount_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_wet"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_reverb_size_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_roomsize"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_reverb_stereo_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_width"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_reverb_damping_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthReverb", 1, "reverb_damp"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_portamento_time_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthInput", 1, "portamento_time"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)


func _on_portamento_mode_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthInput", 1, "portamento_mode"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)

func _on_portamento_keyboard_mode_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthInput", 1, "keyboard_mode"]
	#print(control_name, value)
	amsynth.send_control_channel(control_name, value)
