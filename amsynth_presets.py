#!/usr/bin/env python

import os
import json

base_dir = '/usr/share/amsynth/banks'

values = {
    "osc1_waveform": ["ASynthOsc", 1, "osc_waveform", 1, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 4.0],
    "osc1_pulsewidth": ["ASynthOsc", 1, "osc_pulsewidth", 2, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],

    "osc2_waveform": ["ASynthOsc", 2, "osc_waveform", 7, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 4.0],
    "osc2_pulsewidth": ["ASynthOsc", 2, "osc_pulsewidth", 8, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],
    "osc2_sync": ["ASynthOsc", 2, "osc_sync", 9, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1],
    "osc2_range": ["ASynthDetune", 2, "osc_range", 10, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", -3, 4],
    "osc2_pitch": ["ASynthDetune", 2, "osc_pitch", 11, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", -12, 12],
    "osc2_detune": ["ASynthDetune", 2, "osc_detune", 12, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],

    "osc_mix": ["ASynthMix", 1, "osc_mix", 13, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],
    "osc_mix_mode": ["ASynthMix", 1, "osc_mix_mode", 14, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],

    "amp_attack": ["ASynthAmp", 1, "amp_attack", 15, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "amp_decay": ["ASynthAmp", 1, "amp_decay", 16, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "amp_sustain": ["ASynthAmp", 1, "amp_sustain", 17, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],
    "amp_release": ["ASynthAmp", 1, "amp_release", 18, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],

    "master_vol": ["ASynthRender", 1, "master_vol", 19, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "distortion_crunch": ["ASynthOverDrive", 1, "distortion_crunch", 20, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 0.9],

    "filter_type": ["ASynthFilter", 1, "filter_type", 21, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 4.0],
    "filter_resonance": ["ASynthFilter", 1, "filter_resonance", 22, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 0.97],
    "filter_cutoff": ["ASynthFilter", 1, "filter_cutoff", 23, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -0.5, 1.5],
    "filter_kbd_track": ["ASynthFilter", 1, "filter_kbd_track", 24, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "filter_env_amount": ["ASynthFilter", 1, "filter_env_amount", 25, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -16, 16],
    "filter_attack": ["ASynthFilter", 1, "filter_attack", 26, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "filter_decay": ["ASynthFilter", 1, "filter_decay", 27, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "filter_sustain": ["ASynthFilter", 1, "filter_sustain", 28, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],
    "filter_release": ["ASynthFilter", 1, "filter_release", 29, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],

    "portamento_time": ["ASynthInput", 1, "portamento_time", 30, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "portamento_mode": ["ASynthInput", 1, "portamento_mode", 31, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1],
    "keyboard_mode": ["ASynthInput", 1, "keyboard_mode", 32, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 2],

    "lfo_waveform": ["ASynthLfo", 1, "lfo_waveform", 33, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 6.0],
    "lfo_freq": ["ASynthLfo", 1, "lfo_freq", 34, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 7.5],
    "freq_mod_amount": ["ASynthLfoFreq", 1, "freq_mod_amount", 35, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1.25992105],
    #"freq_mod_amount": ["ASynthLfoFreq", 2, "freq_mod_amount", 36, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1.25992105],
    "filter_mod_amount": ["ASynthFilter", 1, "filter_mod_amount", 37, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],
    "amp_mod_amount": ["ASynthAmp", 1, "amp_mod_amount", 38, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],

    "reverb_wet": ["ASynthReverb", 1, "reverb_wet", 39, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "reverb_roomsize": ["ASynthReverb", 1, "reverb_roomsize", 40, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "reverb_width": ["ASynthReverb", 1, "reverb_width", 41, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "reverb_damp": ["ASynthReverb", 1, "reverb_damp", 42, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],

    "freq_mod_osc": ["ASynthLfoFreq", 1, "freq_mod_osc", 0, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 2.0],
    "freq_mod_osc": ["ASynthLfoFreq", 2, "freq_mod_osc", 0, "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 2.0]
}

midi_presets = {}

for filename in os.listdir(base_dir):
    with open(os.path.join(base_dir, filename), 'r') as f:
        line = ''.join([line.replace('\n', ' ') for line in f.readlines()])
        tokens = line.split(' ')

        state = ''
        name = ''
        parameter_name = ''
        parameter_value = ''

        for token in tokens:
            if state == 'read_name' and not token.startswith('<'):
                if len(name) > 0:
                    name = name + '_' + token
                else:
                    name = token
                midi_presets[name] = []
                continue

            if state == 'read_parameter_name':
                parameter_name = token
                state = 'read_parameter_value'
                continue

            if state == 'read_parameter_value':
                parameter_value = token
                midi_presets[name].append({'symbol': parameter_name, 'value': parameter_value})
                state = ''
                continue

            if token == 'amSynth' or token == '':
                continue

            if token == '<preset>':
                name = ''
                continue

            if token == '<name>':
                state = 'read_name'
                continue

            if token == '<parameter>':
                state = 'read_parameter_name'
                continue

if not os.path.isdir('presets'):
    os.mkdir('presets')

instr_name = "$INSTRUMENT_NAME"

for preset_name, midi_values in midi_presets.items():
    with open(os.path.join('presets', preset_name + '.json'), 'w') as f:
        result = {}
        for midi_value in midi_values:
            name = midi_value['symbol']
            value = midi_value['value']

            if name == "freq_mod_amount":
                component, number, component_name, control, channel_mode, channel_type, midi_min, midi_max = values[name]
                actual_value = (float(value) - midi_min) / (midi_max - midi_min)
                result[control] = actual_value
                result[control+1] = actual_value


            #import ipdb; ipdb.set_trace()
            if name in values:
                component, number, component_name, control, channel_mode, channel_type, midi_min, midi_max = values[name]
                actual_value = (float(value) - midi_min) / (midi_max - midi_min)
                result[control] = actual_value

        #remove freq_mod_amount if not set
        if values["freq_mod_osc"] == 1:
            result[36] = 0
        if values["freq_mod_osc"] == 2:
            result[35] = 0

        # set defaults for osc1_sync osc1_range osc1_pitch osc1_detune
        result[3] = 0
        result[4] = 0.42857142857142855
        result[5] = 0.5
        result[6] = 0.5

        for index in range(1, 43):
            if not index in result:
                result[index] = 0

        f.write(json.dumps(result))
