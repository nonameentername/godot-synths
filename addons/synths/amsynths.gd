extends Node2D

@export
var use_jack: bool = false

@export
var use_distrho: bool = false

var amsynth: CsoundInstance
var channel: int
var parameters: Array[String]


func _ready() -> void:
	if OS.has_feature("web"):
		CsoundServer.open_web_midi_inputs()
	elif "JackServer" in Engine.get_singleton_list() and use_jack:
		Engine.get_singleton("JackServer").open_midi_inputs("godot-synths", 1, 0)
	elif "DistrhoPluginServer" in Engine.get_singleton_list() and use_distrho:
		pass
	else:
		OS.open_midi_inputs()
		print(OS.get_connected_midi_inputs())

	CsoundServer.connect("csound_ready", csound_ready)


func csound_ready(csound_name: String) -> void:
	amsynth = CsoundServer.get_csound(csound_name)
	channel = int(amsynth.evaluate_code("return $INSTRUMENT_CHANNEL"))

	parameters = [
		"one.ASynthOsc.1.osc_waveform",
		"one.ASynthOsc.1.osc_pulsewidth",
		"one.ASynthOsc.1.osc_sync",
		"one.ASynthDetune.1.osc_range",
		"one.ASynthDetune.1.osc_pitch",
		"one.ASynthDetune.1.osc_detune",
		"one.ASynthOsc.2.osc_waveform",
		"one.ASynthOsc.2.osc_pulsewidth",
		"one.ASynthOsc.2.osc_sync",
		"one.ASynthDetune.2.osc_range",
		"one.ASynthDetune.2.osc_pitch",
		"one.ASynthDetune.2.osc_detune",
		"one.ASynthAmp.1.amp_attack",
		"one.ASynthAmp.1.amp_decay",
		"one.ASynthAmp.1.amp_sustain",
		"one.ASynthAmp.1.amp_release",
		"one.ASynthMix.1.osc_mix",
		"one.ASynthMix.1.osc_mix_mode",
		"one.ASynthRender.1.master_vol",
		"one.ASynthOverDrive.1.distortion_crunch",
		"one.ASynthFilter.1.filter_type",
		"one.ASynthFilter.1.filter_resonance",
		"one.ASynthFilter.1.filter_cutoff",
		"one.ASynthFilter.1.filter_kbd_track",
		"one.ASynthFilter.1.filter_env_amount",
		"one.ASynthFilter.1.filter_attack",
		"one.ASynthFilter.1.filter_decay",
		"one.ASynthFilter.1.filter_sustain",
		"one.ASynthFilter.1.filter_release",
		"one.ASynthLfo.1.lfo_waveform",
		"one.ASynthLfo.1.lfo_freq",
		"one.ASynthLfoFreq.1.freq_mod_amount",
		"one.ASynthLfoFreq.2.freq_mod_amount",
		"one.ASynthFilter.1.filter_mod_amount",
		"one.ASynthAmp.1.amp_mod_amount",
		"one.ASynthReverb.1.reverb_wet",
		"one.ASynthReverb.1.reverb_roomsize",
		"one.ASynthReverb.1.reverb_width",
		"one.ASynthReverb.1.reverb_damp",
		"one.ASynthInput.1.portamento_time",
		"one.ASynthInput.1.portamento_mode",
		"one.ASynthInput.1.keyboard_mode"
	]


func _input(input_event):
	if input_event is InputEventMIDI:
		_send_midi_info(input_event)


func _send_midi_info(midi_event):
	print(midi_event)
	print("Channel ", midi_event.channel)
	print("Message ", midi_event.message)
	print("Pitch ", midi_event.pitch)
	print("Velocity ", midi_event.velocity)
	print("Instrument ", midi_event.instrument)
	print("Pressure ", midi_event.pressure)
	print("Controller number: ", midi_event.controller_number)
	print("Controller value: ", midi_event.controller_value)
	print("")

	if midi_event.message == MIDI_MESSAGE_NOTE_ON:
		amsynth.note_on(midi_event.channel, midi_event.pitch, midi_event.velocity)
	if midi_event.message == MIDI_MESSAGE_NOTE_OFF:
		amsynth.note_off(midi_event.channel, midi_event.pitch)
	if midi_event.message == MIDI_MESSAGE_CONTROL_CHANGE:
		amsynth.control_change(midi_event.channel, midi_event.controller_number, midi_event.controller_value)


func _on_amsynth_parameter_changed(parameter: int, value: float) -> void:
	amsynth.send_control_channel(parameters[parameter], value)
