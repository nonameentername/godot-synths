#!/usr/bin/env python

import os
import json

base_dir = '/usr/share/amsynth/banks'

parameters = [
    "osc1_waveform",
    "osc1_pulsewidth",
    "osc1_sync",
    "osc1_range",
    "osc1_pitch",
    "osc1_detune",
    "osc2_waveform",
    "osc2_pulsewidth",
    "osc2_sync",
    "osc2_range",
    "osc2_pitch",
    "osc2_detune",
    "amp_attack",
    "amp_decay",
    "amp_sustain",
    "amp_release",
    "osc_mix",
    "osc_mix_mode",
    "master_vol",
    "distortion_crunch",
    "filter_type",
    "filter_resonance",
    "filter_cutoff",
    "filter_kbd_track",
    "filter_env_amount",
    "filter_attack",
    "filter_decay",
    "filter_sustain",
    "filter_release",
    "lfo_waveform",
    "lfo_freq",
    "osc1_mod_amount",
    "osc2_mod_amount",
    "filter_mod_amount",
    "amp_mod_amount",
    "reverb_wet",
    "reverb_roomsize",
    "reverb_width",
    "reverb_damp",
    "portamento_time",
    "portamento_mode",
    "keyboard_mode"
]

parameter_index = {}

for index, parameter in enumerate(parameters):
    parameter_index[parameter] = index


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

        for index, parameter in enumerate(parameters):
            result[index] = 0

        freq_mod_osc = 0

        for midi_value in midi_values:
            name = midi_value['symbol']
            value = midi_value['value']

            if name == "freq_mod_amount":
                result[parameter_index['osc1_mod_amount']] = value
                result[parameter_index['osc2_mod_amount']] = value

            #import ipdb; ipdb.set_trace()
            if name in parameters:
                result[parameter_index[name]] = value

            if name == 'freq_mod_osc':
                freq_mod_osc = value

        #remove freq_mod_amount if not set
        if freq_mod_osc == 1:
            result[parameter_index['osc2_mod_amount']] = 0
        if freq_mod_osc == 2:
            result[parameter_index['osc1_mod_amount']] = 0

        # set defaults for osc1_sync osc1_range osc1_pitch osc1_detune
        result[parameter_index['osc1_sync']] = 0
        result[parameter_index['osc1_range']] = 0
        result[parameter_index['osc1_pitch']] = 0
        result[parameter_index['osc1_detune']] = 0

        f.write(json.dumps(result))

for index, parameter in enumerate(parameters):
    print (index, parameter)
