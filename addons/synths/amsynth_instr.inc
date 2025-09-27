;instr 2
;
;kcps = 110
;ifn  = 1
;
;knh    line p4, p3, p5
;asig    buzz 1, kcps, knh, ifn
;    outs asig, asig
;endin
;
;
;instr sine
;    SInstrName = "sine"
;    iNum = 1
;    iMidiKey = p5
;    iMidiVelocity = p6
;
;    iFreq mtof iMidiKey
;    iAmp = iMidiVelocity / 127
;
;    aSync init 0
;    iPhase = 0
;    asig oscilikts iAmp, iFreq, 1, aSync, iPhase
;    asig oscils iAmp, iFreq, 0
;
;    chnset 1, SInstrName, "ASynthRender", iNum, "master_vol"
;    chnset 0, SInstrName, "ASynthInput", iNum, "keyboard_mode"
;
;    aSendL, aSendR ASynthRender SInstrName, 1, asig, asig
;    outs aSendL, aSendR
;endin
;
;
;instr forward
;    iMidiKey = p4
;    iMidiVelocity = p5
;
;    kStatus GetMidiStatus
;
;    iInstr nstrnum "$INSTRUMENT_NAME._midi"
;    iChannel = 1
;    iInstrnum = iInstr + iChannel / 100.0 + iMidiKey / 100000.0
;
;    iInstr2 nstrnum "world_midi"
;    iInstrnum2 = iInstr2 + iChannel / 100.0 + iMidiKey / 100000.0
;
;    if kStatus == $MIDI_NOTE_ON then
;        event "i", iInstrnum, 0, -1, iChannel, iMidiKey, iMidiVelocity
;        event "i", iInstrnum2, 0, -1, iChannel, iMidiKey, iMidiVelocity
;    elseif kStatus == $MIDI_NOTE_OFF then
;        event "i", -iInstrnum, 0, 0, iChannel, iMidiKey, iMidiVelocity
;        event "i", -iInstrnum2, 0, 0, iChannel, iMidiKey, iMidiVelocity
;    endif
;endin


instr $INSTRUMENT_NAME
	SInstrName = "$INSTRUMENT_NAME"
	SInstrMixer = "$INSTRUMENT_NAME._mixer"
	aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6
    print p1, p2, p3, p4, p5, p6
	ASynthMixerSend SInstrName, SInstrMixer, aSendL, aSendR
endin

instr $INSTRUMENT_NAME._midi
	SInstrName = "$INSTRUMENT_NAME"
	;iChannel = p4
    iChannel midichn
	iMidiKey = p5
	iMidiVelocity = p6
    print p1, p2, p3, p4, p5, p6
	ASynthInput SInstrName, iChannel, iMidiKey, iMidiVelocity
endin

instr $INSTRUMENT_NAME._mixer

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthOsc", 1, "osc_waveform", $INSTRUMENT_CHANNEL, 1, 0, 4.0, 2
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthOsc", 1, "osc_pulsewidth", $INSTRUMENT_CHANNEL, 2, 0, 1.0, 0.629921019077301
    ;ReadMidiCC "$INSTRUMENT_NAME", "ASynthOsc", 1, "osc_sync", $INSTRUMENT_CHANNEL, 3, 0, 1, 1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthDetune", 1, "osc_range", $INSTRUMENT_CHANNEL, 4, -3, 4, 2
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthDetune", 1, "osc_pitch", $INSTRUMENT_CHANNEL, 5, -12, 12, -1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthDetune", 1, "osc_detune", $INSTRUMENT_CHANNEL, 6, -1, 1, 0.22834600508213

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthOsc", 2, "osc_waveform", $INSTRUMENT_CHANNEL, 7, 0, 4.0, 2
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthOsc", 2, "osc_pulsewidth", $INSTRUMENT_CHANNEL, 8, 0, 1.0, 0.173227995634079
    ;ReadMidiCC "$INSTRUMENT_NAME", "ASynthOsc", 2, "osc_sync", $INSTRUMENT_CHANNEL, 9, 0, 1, 1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthDetune", 2, "osc_range", $INSTRUMENT_CHANNEL, 10, -3, 4, 2
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthDetune", 2, "osc_pitch", $INSTRUMENT_CHANNEL, 11, -12, 12, -1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthDetune", 2, "osc_detune", $INSTRUMENT_CHANNEL, 12, -1, 1, 0.22834600508213

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthMix", 1, "osc_mix", $INSTRUMENT_CHANNEL, 13, -1, 1, -0.244093999266624
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthMix", 1, "osc_mix_mode", $INSTRUMENT_CHANNEL, 14, 0, 1, 0

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_attack", $INSTRUMENT_CHANNEL, 15, 0, 2.5, 0.0750000029802322
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_decay", $INSTRUMENT_CHANNEL, 16, 0, 2.5, 1.55833005905151
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_sustain", $INSTRUMENT_CHANNEL, 17, 0, 1.0, 0
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_release", $INSTRUMENT_CHANNEL, 18, 0, 2.5, 0.706920027732849

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthRender", 1, "master_vol", $INSTRUMENT_CHANNEL, 19, 0, 1, 0.692900002002716
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthOverDrive", 1, "distortion_crunch", $INSTRUMENT_CHANNEL, 20, 0, 0.9, 0

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_type", $INSTRUMENT_CHANNEL, 21, 0, 4.0, 1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_resonance", $INSTRUMENT_CHANNEL, 22, 0, 0.97, 0.036062997579575
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_cutoff", $INSTRUMENT_CHANNEL, 23, -0.5, 1.5, -0.106298997998238
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_kbd_track", $INSTRUMENT_CHANNEL, 24, 0, 1, 0.783333003520966
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_env_amount", $INSTRUMENT_CHANNEL, 25, -16, 16, 1.13385999202728
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_attack", $INSTRUMENT_CHANNEL, 26, 0, 2.5, 0.133332997560501
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_decay", $INSTRUMENT_CHANNEL, 27, 0, 2.5, 0.166666999459267
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_sustain", $INSTRUMENT_CHANNEL, 28, 0, 1.0, 0.0966669991612434
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_release", $INSTRUMENT_CHANNEL, 29, 0, 2.5, 0.86666601896286

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthInput", 1, "portamento_time", $INSTRUMENT_CHANNEL, 30, 0, 1, 0.0133330002427101
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthInput", 1, "portamento_mode", $INSTRUMENT_CHANNEL, 31, 0, 1, 1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthInput", 1, "keyboard_mode", $INSTRUMENT_CHANNEL, 32, 0, 2, 0

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthLfo", 1, "lfo_waveform", $INSTRUMENT_CHANNEL, 33, 0, 6.0, 0
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthLfo", 1, "lfo_freq", $INSTRUMENT_CHANNEL, 34, 0, 7.5, 0
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthLfoFreq", 1, "freq_mod_amount", $INSTRUMENT_CHANNEL, 35, 0, 1.25992105, 0
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthLfoFreq", 2, "freq_mod_amount", $INSTRUMENT_CHANNEL, 36, 0, 1.25992105, 0
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_mod_amount", $INSTRUMENT_CHANNEL, 37, -1, 1, -1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_mod_amount", $INSTRUMENT_CHANNEL, 38, -1, 1, -1

    ;these should be removed
    ;ReadMidiCC "$INSTRUMENT_NAME", "ASynthLfoFreq", 1, "freq_mod_osc", $INSTRUMENT_CHANNEL, x, 0, 2.0, 0
    ;ReadMidiCC "$INSTRUMENT_NAME", "ASynthLfoFreq", 2, "freq_mod_osc", $INSTRUMENT_CHANNEL, x, 0, 2.0, 0

    ReadMidiCC "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_wet", $INSTRUMENT_CHANNEL, 39, 0, 1, 0.0799999982118607
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_roomsize", $INSTRUMENT_CHANNEL, 40, 0, 1, 0.206667006015778
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_width", $INSTRUMENT_CHANNEL, 41, 0, 1, 1
    ReadMidiCC "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_damp", $INSTRUMENT_CHANNEL, 42, 0, 1, 0

	SInstrName = "$INSTRUMENT_NAME"
	SInstrMixer = "$INSTRUMENT_NAME._mixer"
	ASynthEffects SInstrName, SInstrMixer
endin

maxalloc "$INSTRUMENT_NAME", 8, 1
massign $INSTRUMENT_CHANNEL, "$INSTRUMENT_NAME._midi"

DefineChannel "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0750000029802322, 0, 2.5
DefineChannel "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1.55833005905151, 0, 2.5
DefineChannel "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1.0
DefineChannel "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.706920027732849, 0, 2.5
DefineChannel "$INSTRUMENT_NAME", "ASynthOsc", 1, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.133332997560501, 0, 2.5
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.166666999459267, 0, 2.5
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0966669991612434, 0, 1.0
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.86666601896286, 0, 2.5
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_resonance", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.036062997579575, 0, 0.97
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_env_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1.13385999202728, -16, 16
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_cutoff", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.106298997998238, -0.5, 1.5
DefineChannel "$INSTRUMENT_NAME", "ASynthDetune", 2, "osc_detune", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.22834600508213, -1, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthOsc", 2, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "$INSTRUMENT_NAME", "ASynthRender", 1, "master_vol", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.692900002002716, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthLfo", 1, "lfo_freq", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0, 0, 7.5
DefineChannel "$INSTRUMENT_NAME", "ASynthLfo", 1, "lfo_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 6.0
DefineChannel "$INSTRUMENT_NAME", "ASynthDetune", 2, "osc_range", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, -3, 4
DefineChannel "$INSTRUMENT_NAME", "ASynthMix", 1, "osc_mix", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.244093999266624, -1, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthLfoFreq", 1, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "$INSTRUMENT_NAME", "ASynthLfoFreq", 2, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -1, -1, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthAmp", 1, "amp_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -1, -1, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthMix", 1, "osc_mix_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthOsc", 1, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.629921019077301, 0, 1.0
DefineChannel "$INSTRUMENT_NAME", "ASynthOsc", 2, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.173227995634079, 0, 1.0
DefineChannel "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_roomsize", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.206667006015778, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_damp", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_wet", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0799999982118607, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthReverb", 1, "reverb_width", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthOverDrive", 1, "distortion_crunch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 0.9
DefineChannel "$INSTRUMENT_NAME", "ASynthOsc", 1, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthOsc", 2, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthInput", 1, "portamento_time", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0133330002427101, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthInput", 1, "keyboard_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2
DefineChannel "$INSTRUMENT_NAME", "ASynthDetune", 2, "osc_pitch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, -1, -12, 12
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_type", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 4.0
;DefineChannel "$INSTRUMENT_NAME", "ASynthLfoFreq", 1, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
;DefineChannel "$INSTRUMENT_NAME", "ASynthLfoFreq", 2, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "$INSTRUMENT_NAME", "ASynthFilter", 1, "filter_kbd_track", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.783333003520966, 0, 1
DefineChannel "$INSTRUMENT_NAME", "ASynthInput", 1, "portamento_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
