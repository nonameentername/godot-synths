extends Node2D

@export
var instrument_name: String

var amsynth: CsoundGodot

func _ready():
	CsoundServer.csound_layout_changed.connect(csound_layout_changed)


func csound_layout_changed():
	amsynth = CsoundServer.get_csound("amsynth")
	amsynth.csound_ready.connect(initialize)


func initialize() -> void:
	var instrument = """
instr {name}
	SInstrName = "{name}"
	SInstrMixer = "{name}_mixer"
	aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6
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

DefineChannel "{name}", "ASynthAmp", 1, "amp_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.960411012172699, 0, 2.5
DefineChannel "{name}", "ASynthAmp", 1, "amp_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0199999995529652, 0, 2.5
DefineChannel "{name}", "ASynthAmp", 1, "amp_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1.0
DefineChannel "{name}", "ASynthAmp", 1, "amp_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1, 0, 2.5
DefineChannel "{name}", "ASynthOsc", 1, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "{name}", "ASynthFilter", 1, "filter_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.019556999206543, 0, 2.5
DefineChannel "{name}", "ASynthFilter", 1, "filter_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0199999995529652, 0, 2.5
DefineChannel "{name}", "ASynthFilter", 1, "filter_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 1, 1.0
DefineChannel "{name}", "ASynthFilter", 1, "filter_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1.050950050354, 0, 2.5
DefineChannel "{name}", "ASynthFilter", 1, "filter_resonance", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.194335973262787, 0, 0.97
DefineChannel "{name}", "ASynthFilter", 1, "filter_env_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, -16, 16
DefineChannel "{name}", "ASynthFilter", 1, "filter_cutoff", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.851123988628387, -0.5, 1.5
DefineChannel "{name}", "ASynthDetune", 2, "osc_detune", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0118990000337362, -1, 1
DefineChannel "{name}", "ASynthOsc", 2, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "{name}", "ASynthRender", 1, "master_vol", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.955268025398254, 0, 1
DefineChannel "{name}", "ASynthLfo", 1, "lfo_freq", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 2.38652992248535, 0, 7.5
DefineChannel "{name}", "ASynthLfo", 1, "lfo_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 6.0
DefineChannel "{name}", "ASynthDetune", 2, "osc_range", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, -3, 4
DefineChannel "{name}", "ASynthMix", 1, "osc_mix", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0127280000597239, -1, 1
DefineChannel "{name}", "ASynthLfoFreq", 1, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "{name}", "ASynthLfoFreq", 2, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "{name}", "ASynthFilter", 1, "filter_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.863150000572205, -1, 1
DefineChannel "{name}", "ASynthAmp", 1, "amp_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.993574976921082, -1, 1
DefineChannel "{name}", "ASynthMix", 1, "osc_mix_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "{name}", "ASynthOsc", 1, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.788778007030487, 0, 1.0
DefineChannel "{name}", "ASynthOsc", 2, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.829999983310699, 0, 1.0
DefineChannel "{name}", "ASynthReverb", 1, "reverb_roomsize", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.675502002239227, 0, 1
DefineChannel "{name}", "ASynthReverb", 1, "reverb_damp", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.00193100003525615, 0, 1
DefineChannel "{name}", "ASynthReverb", 1, "reverb_wet", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0824249982833862, 0, 1
DefineChannel "{name}", "ASynthReverb", 1, "reverb_width", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.477634012699127, 0, 1
DefineChannel "{name}", "ASynthOverDrive", 1, "distortion_crunch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 0.9
DefineChannel "{name}", "ASynthOsc", 1, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1
DefineChannel "{name}", "ASynthOsc", 2, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1
DefineChannel "{name}", "ASynthInput", 1, "portamento_time", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "{name}", "ASynthInput", 1, "keyboard_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2
DefineChannel "{name}", "ASynthDetune", 2, "osc_pitch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, -12, 12
DefineChannel "{name}", "ASynthFilter", 1, "filter_type", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 4.0
DefineChannel "{name}", "ASynthLfoFreq", 1, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "{name}", "ASynthLfoFreq", 2, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "{name}", "ASynthFilter", 1, "filter_kbd_track", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1
DefineChannel "{name}", "ASynthInput", 1, "portamento_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
""".format({"name": instrument_name})
	amsynth.compile_orchestra(instrument)
	amsynth.input_message('i "{name}_mixer" 0 -1'.format({"name": instrument_name}))


func _process(_delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on:bool) -> void:
	if toggled_on:
		amsynth.instrument_note_on("{name}_midi".format({"name": instrument_name}), 1, 60, 90)
	else:
		amsynth.instrument_note_off("{name}_midi".format({"name": instrument_name}), 1, 60)


func _on_knob_value_changed(value:float) -> void:
	var control_name = "%s.%s.%d.%s" % [instrument_name, "ASynthRender", 1, "master_vol"]
	amsynth.send_control_channel(control_name, value)
