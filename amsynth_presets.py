#!/usr/bin/env python

import os

base_dir = '/usr/share/amsynth/banks'

values = {
    "amp_attack": ["ASynthAmp", 1, "amp_attack", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "amp_decay": ["ASynthAmp", 1, "amp_decay", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "amp_sustain": ["ASynthAmp", 1, "amp_sustain", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],
    "amp_release": ["ASynthAmp", 1, "amp_release", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "osc1_waveform": ["ASynthOsc", 1, "osc_waveform", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 4.0],
    "filter_attack": ["ASynthFilter", 1, "filter_attack", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "filter_decay": ["ASynthFilter", 1, "filter_decay", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "filter_sustain": ["ASynthFilter", 1, "filter_sustain", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 1, 1.0],
    "filter_release": ["ASynthFilter", 1, "filter_release", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 2.5],
    "filter_resonance": ["ASynthFilter", 1, "filter_resonance", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 0.97],
    "filter_env_amount": ["ASynthFilter", 1, "filter_env_amount", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -16, 16],
    "filter_cutoff": ["ASynthFilter", 1, "filter_cutoff", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -0.5, 1.5],
    "osc2_detune": ["ASynthDetune", 2, "osc_detune", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],
    "osc2_waveform": ["ASynthOsc", 2, "osc_waveform", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 4.0],
    "master_vol": ["ASynthRender", 1, "master_vol", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "lfo_freq": ["ASynthLfo", 1, "lfo_freq", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_EXPONENTIAL", 0, 7.5],
    "lfo_waveform": ["ASynthLfo", 1, "lfo_waveform", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 6.0],
    "osc2_range": ["ASynthDetune", 2, "osc_range", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", -3, 4],
    "osc_mix": ["ASynthMix", 1, "osc_mix", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],
    "freq_mod_amount": ["ASynthLfoFreq", 1, "freq_mod_amount", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1.25992105],
    "freq_mod_amount": ["ASynthLfoFreq", 2, "freq_mod_amount", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1.25992105],
    "filter_mod_amount": ["ASynthFilter", 1, "filter_mod_amount", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],
    "amp_mod_amount": ["ASynthAmp", 1, "amp_mod_amount", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", -1, 1],
    "osc_mix_mode": ["ASynthMix", 1, "osc_mix_mode", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "osc1_pulsewidth": ["ASynthOsc", 1, "osc_pulsewidth", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],
    "osc2_pulsewidth": ["ASynthOsc", 2, "osc_pulsewidth", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1.0],
    "reverb_roomsize": ["ASynthReverb", 1, "reverb_roomsize", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "reverb_damp": ["ASynthReverb", 1, "reverb_damp", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "reverb_wet": ["ASynthReverb", 1, "reverb_wet", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "reverb_width": ["ASynthReverb", 1, "reverb_width", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "distortion_crunch": ["ASynthOverDrive", 1, "distortion_crunch", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 0.9],
    "osc2_sync": ["ASynthOsc", 2, "osc_sync", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1],
    "portamento_time": ["ASynthInput", 1, "portamento_time", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "keyboard_mode": ["ASynthInput", 1, "keyboard_mode", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 2],
    "osc2_pitch": ["ASynthDetune", 2, "osc_pitch", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", -12, 12],
    "filter_type": ["ASynthFilter", 1, "filter_type", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 4.0],
    "freq_mod_osc": ["ASynthLfoFreq", 1, "freq_mod_osc", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 2.0],
    "freq_mod_osc": ["ASynthLfoFreq", 2, "freq_mod_osc", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 2.0],
    "filter_kbd_track": ["ASynthFilter", 1, "filter_kbd_track", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_LINEAR", 0, 1],
    "portamento_mode": ["ASynthInput", 1, "portamento_mode", "$CHANNEL_MODE_INPUT", "$CHANNEL_TYPE_INTEGER", 0, 1]
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

instr_name = "{name}"

for preset_name, midi_values in midi_presets.items():
    with open(os.path.join('presets', preset_name + '.inc'), 'w') as f:
        for midi_value in midi_values:
            name = midi_value['symbol']
            value = midi_value['value']

            if name in values:
                component, number, component_name, channel_mode, channel_type, midi_min, midi_max = values[name]
                f.write(f'DefineChannel "{instr_name}", "{component}", {number}, "{component_name}", {channel_mode}, {channel_type}, {value}, {midi_min}, {midi_max}\n')
