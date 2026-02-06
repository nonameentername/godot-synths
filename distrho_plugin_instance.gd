extends DistrhoPluginInstance


func _init() -> void:
	DistrhoPluginServer.set_distrho_plugin(self)


func get_label() -> String:
	return "godot-amsynth"


func get_description() -> String:
	return "Godot AMSynth"


func get_maker() -> String:
	return "nonameentername"


func get_homepage() -> String:
	return "https://github.com/nonameentername/godot-synths"


func get_license() -> String:
	return "LGPL"


func get_version() -> String:
	return "0.0.1"


func get_unique_id() -> String:
	#unique_id should only be 4 characters
	return "GDam"


func get_parameters() -> Array:
	var parameters = [
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE | DistrhoParameter.HINT_PARAMETER_IS_INTEGER,
			"name": "Osc1 Waveform",
			"short_name": "osc1Waveform",
			"symbol": "osc1_waveform",
			"unit": "",
			"default_value": 2,
			"min_value": 0,
			"max_value": 4.0,
			"enumeration_values": {
				"sine": 0,
				"square / pulse": 1,
				"triangle / saw": 2,
				"white noise": 3,
				"noise + sample & hold": 4
			},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc1 Pulsewidth",
			"short_name": "osc1Pulsewidth",
			"symbol": "osc1_pulsewidth",
			"unit": "",
			"default_value": 1,
			"min_value": 0,
			"max_value": 1.0,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc1 Sync",
			"short_name": "osc1Sync",
			"symbol": "osc1_sync",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc1 Range",
			"short_name": "osc1Range",
			"symbol": "osc1_range",
			"unit": "",
			"default_value": 0,
			"min_value": -3,
			"max_value": 4,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc1 Pitch",
			"short_name": "osc1Pitch",
			"symbol": "osc1_pitch",
			"unit": "",
			"default_value": 0,
			"min_value": -12,
			"max_value": 12,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc1 Detune",
			"short_name": "osc1Detune",
			"symbol": "osc1_detune",
			"unit": "",
			"default_value": 0,
			"min_value": -1,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE | DistrhoParameter.HINT_PARAMETER_IS_INTEGER,
			"name": "Osc2 Waveform",
			"short_name": "osc2Waveform",
			"symbol": "osc2_waveform",
			"unit": "",
			"default_value": 2,
			"min_value": 0,
			"max_value": 4.0,
			"enumeration_values": {
				"sine": 0,
				"square / pulse": 1,
				"triangle / saw": 2,
				"white noise": 3,
				"noise + sample & hold": 4
			},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc2 Pulsewidth",
			"short_name": "osc2Pulsewidth",
			"symbol": "osc2_pulsewidth",
			"unit": "",
			"default_value": 1,
			"min_value": 0,
			"max_value": 1.0,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc Sync2",
			"short_name": "oscSync2",
			"symbol": "osc_sync2",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc2 Range",
			"short_name": "osc2Range",
			"symbol": "osc2_range",
			"unit": "",
			"default_value": 0,
			"min_value": -3,
			"max_value": 4,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc2 Pitch",
			"short_name": "osc2Pitch",
			"symbol": "osc2_pitch",
			"unit": "",
			"default_value": 0,
			"min_value": -12,
			"max_value": 12,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc2 Detune",
			"short_name": "osc2Detune",
			"symbol": "osc2_detune",
			"unit": "",
			"default_value": 0,
			"min_value": -1,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Amp Attack",
			"short_name": "ampAttack",
			"symbol": "amp_attack",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Amp Decay",
			"short_name": "ampDecay",
			"symbol": "amp_decay",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Amp Sustain",
			"short_name": "ampSustain",
			"symbol": "amp_sustain",
			"unit": "",
			"default_value": 1,
			"min_value": 0,
			"max_value": 1.0,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Amp Release",
			"short_name": "ampRelease",
			"symbol": "amp_release",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc Mix",
			"short_name": "oscMix",
			"symbol": "osc_mix",
			"unit": "",
			"default_value": 0,
			"min_value": -1,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc Mix Mode",
			"short_name": "oscMixMode",
			"symbol": "osc_mix_mode",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Master Vol",
			"short_name": "masterVol",
			"symbol": "master_vol",
			"unit": "",
			"default_value": 0.67,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Distortion Crunch",
			"short_name": "distortionCrunch",
			"symbol": "distortion_crunch",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 0.9,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE | DistrhoParameter.HINT_PARAMETER_IS_INTEGER,
			"name": "Filter Type",
			"short_name": "filterType",
			"symbol": "filter_type",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 4.0,
			"enumeration_values": {
				"low pass": 0,
				"high pass": 1,
				"band pass": 2
			},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Resonance",
			"short_name": "filterResonance",
			"symbol": "filter_resonance",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 0.97,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Cutoff",
			"short_name": "filterCutoff",
			"symbol": "filter_cutoff",
			"unit": "",
			"default_value": 1.5,
			"min_value": -0.5,
			"max_value": 1.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Key Track",
			"short_name": "filterKbdTrack",
			"symbol": "filter_kbd_track",
			"unit": "",
			"default_value": 1,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Env Amount",
			"short_name": "filterEnvAmount",
			"symbol": "filter_env_amount",
			"unit": "",
			"default_value": 0,
			"min_value": -16,
			"max_value": 16,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Attack",
			"short_name": "filterAttack",
			"symbol": "filter_attack",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Decay",
			"short_name": "filterDecay",
			"symbol": "filter_decay",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Sustain",
			"short_name": "filterSustain",
			"symbol": "filter_sustain",
			"unit": "",
			"default_value": 1,
			"min_value": 0,
			"max_value": 1.0,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Release",
			"short_name": "filterRelease",
			"symbol": "filter_release",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE | DistrhoParameter.HINT_PARAMETER_IS_INTEGER,
			"name": "LFO Waveform",
			"short_name": "lfoWaveform",
			"symbol": "lfo_waveform",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 6.0,
			"enumeration_values": {
				"sine": 0,
				"square": 1,
				"triangle": 2,
				"white noise": 3,
				"noise + sample & hold": 4,
				"sawtooth (up)": 5,
				"sawtooth (down)": 6
			},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "LFO Freq",
			"short_name": "lfoFreq",
			"symbol": "lfo_freq",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 7.5,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc1 Mod Amount",
			"short_name": "osc1ModAmount",
			"symbol": "osc1_mod_amount",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1.25992105,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Osc2 Mod Amount",
			"short_name": "osc2ModAmount",
			"symbol": "osc2_mod_amount",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1.25992105,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Filter Mod Amount",
			"short_name": "filterModAmount",
			"symbol": "filter_mod_amount",
			"unit": "",
			"default_value": -1,
			"min_value": -1,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Amp Mod Amount",
			"short_name": "ampModAmount",
			"symbol": "amp_mod_amount",
			"unit": "",
			"default_value": -1,
			"min_value": -1,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Reverb Wet",
			"short_name": "reverbWet",
			"symbol": "reverb_wet",
			"unit": "",
			"default_value": 0.0799999982118607,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Reverb Roomsize",
			"short_name": "reverbRoomsize",
			"symbol": "reverb_roomsize",
			"unit": "",
			"default_value": 0.206667006015778,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Reverb Width",
			"short_name": "reverbWidth",
			"symbol": "reverb_width",
			"unit": "",
			"default_value": 1,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Reverb Damp",
			"short_name": "reverbDamp",
			"symbol": "reverb_damp",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE,
			"name": "Portamento Time",
			"short_name": "portamentoTime",
			"symbol": "portamento_time",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE | DistrhoParameter.HINT_PARAMETER_IS_INTEGER,
			"name": "Portamento Mode",
			"short_name": "portamentoMode",
			"symbol": "portamento_mode",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 1,
			"enumeration_values": {
				"always": 0,
				"legato": 1
			},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		},
		{
			"hints": DistrhoParameter.HINT_PARAMETER_IS_AUTOMATABLE | DistrhoParameter.HINT_PARAMETER_IS_INTEGER,
			"name": "Keyboard Mode",
			"short_name": "keyboardMode",
			"symbol": "keyboard_mode",
			"unit": "",
			"default_value": 0,
			"min_value": 0,
			"max_value": 2,
			"enumeration_values": {
				"poly": 0,
				"mono": 1,
				"legato": 2
			},
			"designation": DistrhoParameter.PARAMETER_DESIGNATION_NONE,
			"group_id": DistrhoParameter.PORT_GROUP_NONE
		}
	]
	return parameters.map(DistrhoPluginServer.create_parameter)


func get_input_ports() -> Array:
	var ports = [
		{
			"hints": DistrhoAudioPort.HINT_NONE,
			"name": "Input Left",
			"symbol": "input_left",
			"group_id": DistrhoAudioPort.PORT_GROUP_STEREO
		},
		{
			"hints": DistrhoAudioPort.HINT_NONE,
			"name": "Input Right",
			"symbol": "input_right",
			"group_id": DistrhoAudioPort.PORT_GROUP_STEREO
		}
	]

	return ports.map(DistrhoPluginServer.create_audio_port)


func get_output_ports() -> Array:
	var ports = [
		{
			"hints": DistrhoAudioPort.HINT_NONE,
			"name": "Output Left",
			"symbol": "output_left",
			"group_id": DistrhoAudioPort.PORT_GROUP_STEREO
		},
		{
			"hints": DistrhoAudioPort.HINT_NONE,
			"name": "Output Right",
			"symbol": "output_right",
			"group_id": DistrhoAudioPort.PORT_GROUP_STEREO
		}
	]

	return ports.map(DistrhoPluginServer.create_audio_port)
