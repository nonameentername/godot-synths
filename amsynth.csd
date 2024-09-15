<CoundSynthesizer>
<CsOptions>
--midi-key=5 --midi-velocity=6 -n
;-+rtmidi=NULL -M0 --midi-key=5 --midi-velocity=6 -n
</CsOptions>
<CsInstruments>

#define DEBUG #1#

#define MIDI_NO_MESAGE #0#
#define MIDI_NOTE_OFF #128#
#define MIDI_NOTE_ON #144#

#define KEY_MODE_POLY #0#
#define KEY_MODE_MONO #1#
#define KEY_MODE_LEGATO #2#

#define PORTAMENTO_ALWAYS #0#
#define PORTAMENTO_LEGATO #1#

#define MAX_NUM_VOICES #16#
#define MAX_NUM_INSTRUMENTS #1024#

#define CHANNEL_MODE_INPUT #1#
#define CHANNEL_MODE_OUTPUT #2#
#define CHANNEL_MODE_BOTH #3#

#define CHANNEL_TYPE_DEFAULT #0#
#define CHANNEL_TYPE_INTEGER #1#
#define CHANNEL_TYPE_LINEAR #2#
#define CHANNEL_TYPE_EXPONENTIAL #3#

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

massign 0, 0

isf sfload  "assets/FluidR3_GM.sf2"
sfpassign   0, isf

giSquarePulse[] init 128
giTriangleSaw[] init 128

iTableSize = 16384

iIndex = 0
while iIndex <= 127 do
    iScale min iIndex / 127, 0.9
    iSize = (1 - iScale) / 2
    iWidth round iSize * iTableSize
    iTableNumber ftgen 0, 0, iTableSize, 7, 1, iTableSize - iWidth, 1, 0, -1, iWidth, -1
    giSquarePulse[iIndex] = iTableNumber
    iIndex = iIndex + 1
od

;SValue sprintf "table_%d.ftsave", iTableNumber
;ftsave SValue, 1, iTableNumber

iIndex = 0
while iIndex <= 127 do
    iScale = iIndex / 127
    iSize = (1 - iScale) / 2
    iWidth round iSize * iTableSize
    if iWidth % 2 == 1 then
        iWidth = iWidth - 1
    endif
    iTableNumber ftgen 0, 0, iTableSize, 7, 0, (iTableSize - iWidth) / 2, 1, iWidth, -1, (iTableSize - iWidth) / 2, 0
    giTriangleSaw[iIndex] = iTableNumber
    iIndex = iIndex + 1
od


opcode GetChannelName, S, SSiS
SInstrName, SComponent, iIndex, SName xin

iInstr nstrnum SInstrName
;SValue sprintf "_%d_%d_%s", iInstr, iIndex, SName
SValue sprintf "%s.%s.%d.%s", SInstrName, SComponent, iIndex, SName

xout SValue
endop


opcode chnget, a, SSiS
SInstrName, SComponent, iIndex, SName xin

SInternalName GetChannelName SInstrName, SComponent, iIndex, SName
aValue chnget SInternalName

xout aValue
endop


opcode chnget, k, SSiS
SInstrName, SComponent, iIndex, SName xin

SInternalName GetChannelName SInstrName, SComponent, iIndex, SName
kValue chnget SInternalName

xout kValue
endop


opcode chnget, i, SSiS
SInstrName, SComponent, iIndex, SName xin

SInternalName GetChannelName SInstrName, SComponent, iIndex, SName
iValue chnget SInternalName

xout iValue
endop


opcode chnset, 0, aSSiS
aValue, SInstrName, SComponent, iIndex, SName xin

SInternalName GetChannelName SInstrName, SComponent, iIndex, SName
chnset aValue, SInternalName
endop


opcode chnset, 0, kSSiS
kValue, SInstrName, SComponent, iIndex, SName xin

SInternalName GetChannelName SInstrName, SComponent, iIndex, SName
chnset kValue, SInternalName
endop


opcode chnseti, 0, iSSiS
iValue, SInstrName, SComponent, iIndex, SName xin

SInternalName GetChannelName SInstrName, SComponent, iIndex, SName
chnset iValue, SInternalName

#ifdef DEBUG
;prints "%s = %f\n", SInternalName, iValue
#end

endop


opcode GetNumHeld, k, k[][]i
kKeys[][], iChannel xin

kCount = 0
kIndex = 0
while kIndex <= 127 do
    if kKeys[iChannel][kIndex] > 0 then
        kCount = kCount + 1
    endif
    kIndex = kIndex + 1
od

xout kCount
endop


opcode GetMax1, k, k[]k
kKeys[], kValue xin

kMax = 0
kIndex = 0
until kIndex == 128 do
    if kKeys[kIndex] > kKeys[kMax] then
        kMax = kIndex
    endif
    kIndex = kIndex + 1
od
if kKeys[kMax] > 0 then
    kValue = kMax
endif

xout kValue
endop


opcode GetMax, k, k[][]ik
kKeys[][], iChannel, kValue xin

kMax = 0
kIndex = 0
until kIndex == 128 do
    if kKeys[iChannel][kIndex] > kKeys[iChannel][kMax] then
        kMax = kIndex
    endif
    kIndex = kIndex + 1
od
if kKeys[iChannel][kMax] > 0 then
    kValue = kMax
endif

xout kValue
endop


opcode GetMin, k, k[]k
kKeys[], kValue xin

kmin = 0
kIndex = 0
until kIndex == 128 do
    if kKeys[kIndex] != 0 && kKeys[kmin] != 0 && kKeys[kIndex] < kKeys[kmin] then
        kmin = kIndex
    elseif kKeys[kmin] == 0 && kKeys[kIndex] != 0 then
        kmin = kIndex
    endif
    kIndex = kIndex + 1
od
if kKeys[kmin] > 0 then
    kValue = kmin
endif

xout kValue
endop


opcode Toggle, k, k
kValue xin

if kValue == 100 then
    kValue = 0
else
    kValue = kValue + 1
endif

xout kValue
endop


opcode GetMidiStatus, k, 0

kStatus init $MIDI_NO_MESAGE
kStart init 1
kEnd release

if kStart == 1 then
    kStatus = $MIDI_NOTE_ON
    kStart = 0
elseif kEnd == 1 then
    kStatus = $MIDI_NOTE_OFF
else
    kStatus = $MIDI_NO_MESAGE
endif

xout kStatus
endop


opcode GetLineSegr, k, iiii
iAttack, iDecay, iSustain, iRelease xin

iTie tival

if iTie == 1 then
    kEnv linsegr 1,iDecay,iSustain,iRelease,0
else
    kEnv linsegr 0,iAttack,1,iDecay,iSustain,iRelease,0
endif

xout kEnv
endop


opcode DefineChannel, 0, SSiSiiiii
SInstrName, SComponent, iNum, SName, iMode, iType, iDefault, iMin, iMax xin

SInternalName GetChannelName SInstrName, SComponent, iNum, SName
iX = 0
iY = 0
iWidth = 0
iHeight = 0
SAttributes sprintf "instrument=%s,component=%s,index=%d", SInstrName, SComponent, iNum
if iType == $CHANNEL_TYPE_EXPONENTIAL then
    iType = $CHANNEL_TYPE_LINEAR
endif
chn_k SInternalName, iMode, iType, iDefault, iMin, iMax, iX, iY, iWidth, iHeight, SAttributes

chnseti(iDefault, SInstrName, SComponent, iNum, SName)
endop


gkHeldKeys[][]  init $MAX_NUM_INSTRUMENTS, 128
gkCounter[] init $MAX_NUM_INSTRUMENTS
gkPrevNote[] init $MAX_NUM_INSTRUMENTS
gkLargestHeldKey[] init $MAX_NUM_INSTRUMENTS
gkMidiVelocity[] init $MAX_NUM_INSTRUMENTS
gkCurrentNote[] init $MAX_NUM_INSTRUMENTS
gkUpdatePortamento[] init $MAX_NUM_INSTRUMENTS

#define gkHeldKeys #gkHeldKeys[iChannel]#
#define gkCounter #gkCounter[iChannel]#
#define gkPrevNote #gkPrevNote[iChannel]#
#define gkLargestHeldKey #gkLargestHeldKey[iChannel]#
#define gkMidiVelocity #gkMidiVelocity[iChannel]#
#define gkCurrentNote #gkCurrentNote[iChannel]#
#define gkUpdatePortamento #gkUpdatePortamento[iChannel]#

opcode ASynthInput, 0, Siii
SInstrName, iChannel, iMidiKey, iMidiVelocity xin

SString1 sprintf "ASynthInput: %s iChannel = %d iMidiKey = %d iMidiVelocity = %d\n", SInstrName, iChannel, iMidiKey, iMidiVelocity
kRes strToFile SString1, "debug.txt", 1

iInstr nstrnum SInstrName
iNum = 1

if iMidiVelocity > 0 then
    iStatus = $MIDI_NOTE_ON
else
    iStatus = $MIDI_NOTE_OFF
endif

iKeyboardModeMidi chnget SInstrName, "ASynthInput", iNum, "keyboard_mode"
iKeyboardMode round iKeyboardModeMidi

iPortamentoModeMidi chnget SInstrName, "ASynthInput", iNum, "portamento_mode"
kPortamentoMode round iPortamentoModeMidi

;TODO: readd turning off all instruments
;kKeyboardModeChanged changed2 kKeyboardModeMidi
;
;if kKeyboardModeChanged == 1 then
;    turnoff2 iInstr, 0, 0
;endif

kAllInstrCount active iInstr, 0, 0
kActiveInstrCount active iInstr, 0, 1

;print kAllInstrCount, kActiveInstrCount

if iKeyboardMode == $KEY_MODE_POLY then
    iInstrnum = iInstr + iChannel / 100.0 + iMidiKey / 100000.0;
else
    iInstrnum = iInstr + iChannel / 100.0
    ;iInstrnum = iInstr + iChannel / 100.0 + iMidiKey / 100000.0;
endif

;prints "%s = %f\n", "iInstrnum = ", iInstrnum

;printk 1, kInstrCount, 0, 1
;printk 1, kInstrnum, 0, 1

if iKeyboardMode == $KEY_MODE_POLY then
    if iStatus == $MIDI_NOTE_ON then
        chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
        event "i", iInstrnum, 0, -1, iChannel, iMidiKey, iMidiVelocity
    elseif iStatus == $MIDI_NOTE_OFF then
        chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
        event "i", -iInstrnum, 0, 0, iChannel, iMidiKey, iMidiVelocity
    endif
else
    if iStatus == $MIDI_NOTE_ON then
        SString0 = "note_on\n"
        kRes strToFile SString0, "debug.txt", 1

        $gkCurrentNote = iMidiKey
        $gkMidiVelocity = iMidiVelocity

        kNumHeldKeys GetNumHeld gkHeldKeys, iChannel

        SString01 sprintfk "werner: %s kNumHeldKeys = %d\n", SInstrName, kNumHeldKeys
        kRes strToFile SString01, "debug.txt", 1

        if kNumHeldKeys == 0 then
            SString1 = "note_on 1\n"
            kRes strToFile SString1, "debug.txt", 1
            chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
            chnset iMidiKey, SInstrName, "ASynthInput", iNum, "current_note"
            event "i", iInstrnum, 0, -1, iChannel, iMidiKey, iMidiVelocity
        else
            if iKeyboardMode == $KEY_MODE_MONO then
                SString2 = "note_on 2\n"
                kRes strToFile SString2, "debug.txt", 1
                chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
                chnset iMidiKey, SInstrName, "ASynthInput", iNum, "current_note"
                event "i", iInstrnum, 0, -1, iChannel, iMidiKey, iMidiVelocity
            elseif iKeyboardMode == $KEY_MODE_LEGATO then
                SString3 = "note_on 3\n"
                kRes strToFile SString3, "debug.txt", 1
                chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
                chnset iMidiKey, SInstrName, "ASynthInput", iNum, "current_note"
                $gkUpdatePortamento Toggle $gkUpdatePortamento
            endif
        endif
    elseif iStatus == $MIDI_NOTE_OFF then
        SString = "note_off\n"
        kRes strToFile SString, "debug.txt", 1

        $gkHeldKeys[iMidiKey] = 0
        kLargestHeldKey GetMax gkHeldKeys, iChannel, 0
        if kLargestHeldKey == 0 then
            SString = "note_off 1\n"
            kRes strToFile SString, "debug.txt", 1
            chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
            chnset 0, SInstrName, "ASynthInput", iNum, "current_note"
            event "i", -iInstrnum, 0, 0, iChannel, iMidiKey, iMidiVelocity
        elseif iKeyboardMode == $KEY_MODE_MONO then
            if iMidiKey > kLargestHeldKey && kLargestHeldKey != $gkCurrentNote then
                SString = "note_off 2\n"
                kRes strToFile SString, "debug.txt", 1
                $gkCurrentNote = kLargestHeldKey
                chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
                event "i", iInstrnum, 0, -1, iChannel, kLargestHeldKey, $gkMidiVelocity
            endif
        elseif iKeyboardMode == $KEY_MODE_LEGATO then
            if iMidiKey > kLargestHeldKey && kLargestHeldKey != $gkCurrentNote then
                SString = "note_off 3\n"
                kRes strToFile SString, "debug.txt", 1
                chnset $gkPrevNote, SInstrName, "ASynthInput", iNum, "prev_note"
                chnset kLargestHeldKey, SInstrName, "ASynthInput", iNum, "current_note"
                $gkUpdatePortamento Toggle $gkUpdatePortamento
            endif
        endif
    endif
endif

;printk 1, kLargestHeldKey, 0, 1

if iStatus == $MIDI_NOTE_ON then
    $gkCounter = $gkCounter + 1
    $gkPrevNote = iMidiKey
    SString11 sprintfk "note_on: %s gkPrevNote = %d\n", SInstrName, $gkPrevNote
    kRes strToFile SString11, "debug.txt", 1

    $gkLargestHeldKey = iMidiKey
    $gkHeldKeys[$gkLargestHeldKey] = $gkCounter

elseif iStatus == $MIDI_NOTE_OFF then
    $gkHeldKeys[iMidiKey] = 0
    kLargestHeldKey GetMax gkHeldKeys, iChannel, 0
    if kLargestHeldKey == 1 then
        $gkCounter = 0
    endif

    $gkLargestHeldKey GetMax gkHeldKeys, iChannel, $gkLargestHeldKey

    kNumHeldKeys GetNumHeld gkHeldKeys, iChannel
    if kPortamentoMode == $PORTAMENTO_LEGATO && kNumHeldKeys == 0 then
        $gkPrevNote = 0
    else
		if iKeyboardMode != $KEY_MODE_POLY then
			$gkPrevNote = $gkLargestHeldKey
		endif
    endif
endif

endop


opcode FSynthOsc, aa, Siika
SInstrName, iNum, iAmp, iFreq, aSyncIn xin

iShapeMidi chnget SInstrName, "ASynthOsc", iNum, "osc_pulsewidth"
iShape = iShapeMidi * 127
iShape round iShape

kSyncMidi chnget SInstrName, "ASynthOsc", iNum, "osc_sync"
kSync round kSyncMidi 

if kSync == 1 then
    aSync diff 1 - aSyncIn
    aPhasor phasor iFreq
else
    aSync init 0
    aPhasor init 0
endif

iNote = 69+12*log2(iFreq/440)

;print iNote, iFreq

kAmp = 1/15000 * 10
aOut sfplaym 64, 64, kAmp*iAmp, iFreq, 0, 1

xout aOut, aPhasor
endop


opcode ASynthOsc, aa, Siika
SInstrName, iNum, iAmp, kFreq, aSyncIn xin

kTypeMidi chnget SInstrName, "ASynthOsc", iNum, "osc_waveform"
kType round kTypeMidi

kShapeMidi chnget SInstrName, "ASynthOsc", iNum, "osc_pulsewidth"
kShape scale kShapeMidi, 126, 0
kShape round kShape

kSyncMidi chnget SInstrName, "ASynthOsc", iNum, "osc_sync"
kSync round kSyncMidi 

if kSync == 1 then
    aSync diff 1 - aSyncIn
    aPhasor phasor kFreq
else
    aSync init 0
    aPhasor init 0
endif

iPhase = 0

;printk 1, kFreq, 0, 1
;printk 1, iAmp, 0, 1

if kType == 0 then
    ;sine wave
    ;aOut oscilikts iAmp, kFreq, 1, aSync, iPhase
    aOut oscilikt iAmp, kFreq, 1, iPhase
    ;aOut oscils iAmp, kFreq, iPhase
elseif kType == 1 then
    ;square / pulse
    ;aOut oscilikts iAmp, kFreq, giSquarePulse[kShape], aSync, iPhase
    aOut oscilikt iAmp, kFreq, giSquarePulse[kShape], iPhase
elseif kType == 2 then
    ;triangle / saw
    ;aOut oscilikts iAmp, kFreq, giTriangleSaw[kShape], aSync, iPhase
    aOut oscilikt iAmp, kFreq, giTriangleSaw[kShape], iPhase
elseif kType == 3 then
    ;white noise
    aOut noise iAmp, 0.0
else
    ;noise + sample & hold
    aOut randh iAmp, kFreq
endif

xout aOut, aPhasor
endop


opcode ASynthDetune, k, Sik
SInstrName, iNum, kFreq xin

kOctaveMidi chnget SInstrName, "ASynthDetune", iNum, "osc_range"
kOctave round kOctaveMidi
kOctave octave kOctave

kSemitoneMidi chnget SInstrName, "ASynthDetune", iNum, "osc_pitch"
kSemitone round kSemitoneMidi
kSemitone semitone kSemitone

kDetuneMidi chnget SInstrName, "ASynthDetune", iNum, "osc_detune"
kDetune pow 1.25, kDetuneMidi
kDetune = 1200 * log2(kDetune)
kDetune2 cent kDetune

kValue = kFreq * kOctave * kSemitone * kDetune2

;printk 1, kFreq, 0, 1
;printk 1, kOctave, 0, 1
;printk 1, kSemitone, 0, 1
;printk 1, kDetune, 0, 1
;printk 1, kDetune2, 0, 1
;printk 1, kValue, 0, 1

xout kValue
endop


opcode ASynthLfo, a, Sik
SInstrName, iNum, kFreq xin

kTypeMidi chnget SInstrName, "ASynthLfo", iNum, "lfo_waveform"
kType round kTypeMidi 

kLfoFreqMidi chnget SInstrName, "ASynthLfo", iNum, "lfo_freq"
kLfoFreq pow kLfoFreqMidi, 2

if kType == 0 then
    ;sine
    aOut lfo 1, kLfoFreq, 0
elseif kType == 1 then
    ;square
    aOut lfo 1, kLfoFreq, 2
elseif kType == 2 then
    ;triangle
    aOut lfo 1, kLfoFreq, 1
elseif kType == 3 then
    ;white noise
    aOut noise 1, 0.0
elseif kType == 4 then
    ;noise + sample & hold
    if kLfoFreq == 0 then
        kLfoFreq = kFreq
    endif
    aOut randh 1, kLfoFreq
elseif kType == 5 then
    ;sawtooth up
    aOut lfo 1, kLfoFreq, 4
else
    ;sawtooth down
    aOut lfo 1, kLfoFreq, 5
endif

xout aOut
endop


opcode ASynthFilter, a, Siaakk
SInstrName, iNum, aIn, aLfo, kFreq, kVelocity xin

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99
i16 = 1 / 16

iAttackMidi chnget SInstrName, "ASynthFilter", iNum, "filter_attack"
iAttack pow iAttackMidi, 3
iAttack = iAttack + 0.0005

iDecayMidi chnget SInstrName, "ASynthFilter", iNum, "filter_decay"
iDecay pow iDecayMidi, 3
iDecay = iDecay + 0.0005

iSustainMidi chnget SInstrName, "ASynthFilter", iNum, "filter_sustain"
iSustain = iSustainMidi

iReleaseMidi chnget SInstrName, "ASynthFilter", iNum, "filter_release"
iRelease pow iReleaseMidi, 3
iRelease = iRelease + 0.0005

kResonanceMidi chnget SInstrName, "ASynthFilter", iNum, "filter_resonance"
kResonance scale kResonanceMidi, 20.0, 1.0

kEnvAmountMidi chnget SInstrName, "ASynthFilter", iNum, "filter_env_amount"
kEnvAmount = kEnvAmountMidi

kCutoffMidi chnget SInstrName, "ASynthFilter", iNum, "filter_cutoff"
kCutoff pow 16, kCutoffMidi

kTypeMidi chnget SInstrName, "ASynthFilter", iNum, "filter_type"
kType round kTypeMidi

kKeyTrackMidi chnget SInstrName, "ASynthFilter", iNum, "filter_kbd_track"
kKeyTrack = kKeyTrackMidi 

kLfoFilterAmountMidi chnget SInstrName, "ASynthFilter", iNum, "filter_mod_amount"
kLfoFilterAmount = kLfoFilterAmountMidi 
kLfoFilterAmount = kLfoFilterAmount / 2 + 0.5

kCutoffLfo = ( aLfo * 0.5 + 0.5 ) * kLfoFilterAmount + 1 - kLfoFilterAmount

kCutoffBase = iTrackBaseFreq * (1 - kKeyTrack) + kFreq * kKeyTrack

kCutoff = kCutoff * kCutoffBase * kVelocity * kCutoffLfo

kFilterEnv GetLineSegr iAttack, iDecay, iSustain, iRelease

if kEnvAmount > 0 then
    kCutoff = kCutoff + kFreq * kFilterEnv * kEnvAmount
else
    kCutoff = kCutoff + kCutoff * i16 * kEnvAmount * kFilterEnv
endif

kCutoff min kCutoff, iMiddle
kCutoff max kCutoff, 10

if kType == 0 then
    ;lowpass
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 0
elseif kType == 1 then
    ;highpass
    aOut rbjeq aIn, 1 - kCutoff, 1, kResonance, 1, 2
elseif kType == 2 then
    ;bandpass
    kResonance scale kResonanceMidi, 25.0, 1.0
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 4
elseif kType == 3 then
    ;band-reject
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 6
else
    ;peaking eq
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 8
endif

xout aOut
endop


opcode ASynthMix, a, Siaa
SInstrName, iNum, aOsc1, aOsc2 xin

kOscMixMidi chnget SInstrName, "ASynthMix", iNum, "osc_mix"
kOscMix = kOscMixMidi

kOscRingModMidi chnget SInstrName, "ASynthMix", iNum, "osc_mix_mode"
kOscRingMod = kOscRingModMidi

kOsc1Vol = (1 - kOscMix) / 2
kOsc1Vol = kOsc1Vol * (1 - kOscRingMod)

kOsc2Vol = (1 + kOscMix) / 2
kOsc2Vol = kOsc2Vol * (1 - kOscRingMod)

aOut = aOsc1 * kOsc1Vol + aOsc2 * kOsc2Vol + kOscRingMod * aOsc1 * aOsc2

xout aOut
endop


opcode ASynthAmp, a, Siaa
SInstrName, iNum, aIn, aLfo xin

iAttackMidi chnget SInstrName, "ASynthAmp", iNum, "amp_attack"
iAttack pow iAttackMidi, 3
iAttack = iAttack + 0.0005

;declick
if iAttack < 0.01 then
    iAttack = 0.01
endif

iDecayMidi chnget SInstrName, "ASynthAmp", iNum, "amp_decay"
iDecay pow iDecayMidi, 3
iDecay = iDecay + 0.0005

iSustainMidi chnget SInstrName, "ASynthAmp", iNum, "amp_sustain"
iSustain = iSustainMidi

iReleaseMidi chnget SInstrName, "ASynthAmp", iNum, "amp_release"
iRelease pow iReleaseMidi, 3
iRelease = iRelease + 0.0005

;declick
if iRelease < 0.05 then
    iRelease = 0.05
endif

kLfoAmpMidi chnget SInstrName, "ASynthAmp", iNum, "amp_mod_amount"
kLfoAmp = kLfoAmpMidi
kLfoAmp = ( kLfoAmp + 1 ) / 2

kEnvLfo = ( ( aLfo * 0.5 + 0.5 ) * kLfoAmp + 1 - kLfoAmp )

kEnv GetLineSegr iAttack, iDecay, iSustain, iRelease
kEnv = kEnv * kEnvLfo
aOut = aIn * kEnv

xout aOut
endop


opcode ASynthOverDrive, a, Sia
SInstrName, iNum, aIn xin

kDistMidi chnget SInstrName, "ASynthOverDrive", iNum, "distortion_crunch"
kDist = kDistMidi 

kCrunch = 1 - kDist
if kCrunch == 0 then
    kCrunch = 0.01
endif

aOut powershape aIn, kCrunch

xout aOut
endop


opcode ASynthOverDrive, aa, Siaa
SInstrName, iNum, aInLeft, aInRight xin

aOutLeft ASynthOverDrive SInstrName, iNum, aInLeft
aOutRight ASynthOverDrive SInstrName, iNum, aInRight

xout aOutLeft, aOutRight
endop


opcode ASynthReverb, aa, Siaa
SInstrName, iNum, aInLeft, aInRight xin

kReverbAmountMidi chnget SInstrName, "ASynthReverb", iNum, "reverb_wet"
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget SInstrName, "ASynthReverb", iNum, "reverb_roomsize"
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget SInstrName, "ASynthReverb", iNum, "reverb_width"
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget SInstrName, "ASynthReverb", iNum, "reverb_damp"
kReverbDamp  = kReverbDampMidi

aReverbL, aReverbR freeverb aInLeft, aInRight, kReverbSize, kReverbDamp

kWet1 = kReverbAmount * ( kReverbWidth / 2 + 0.5 )
kWet2 = kReverbAmount * ( ( 1 - kReverbWidth ) / 2 )
kDry = 1 - kReverbAmount

aInput = aInLeft + aInRight * 0.015

aOutLeft = aReverbL * kWet1 + aReverbR * kWet2 + aInput * kDry
aOutRight = aReverbR * kWet1 + aReverbL * kWet2 + aInput * kDry

xout (aOutLeft + aInLeft) / 2, (aOutRight + aInRight) / 2
endop


opcode ASynthMixerReceive, aa, SS
SInstrName, SInstrMixer xin

iInstr nstrnum SInstrName
iInstrMixer nstrnum SInstrMixer

kLevel MixerGetLevel iInstr, iInstrMixer
aSendL MixerReceive iInstrMixer, 0
aSendR MixerReceive iInstrMixer, 1

xout aSendL * kLevel, aSendR * kLevel
endop


opcode ASynthOut, 0, Siaa
SInstrName, iNum, aSendL, aSendR xin

outs aSendL, aSendR
clear aSendL, aSendR

endop


opcode ASynthEffects, 0, SS
SInstrName, SInstrMixer xin

iNum = 1

aSendL, aSendR ASynthMixerReceive SInstrName, SInstrMixer
aSendL, aSendR ASynthOverDrive SInstrName, iNum, aSendL, aSendR
aSendL, aSendR ASynthReverb SInstrName, iNum, aSendL, aSendR

aClipL clip aSendL, 0, 0.9
aClipR clip aSendR, 0, 0.9

ASynthOut SInstrName, iNum, aClipL, aClipR

endop


opcode ASynthPortamento, k, Siii
SInstrName, iNum, iMidiKey, iChannel xin

iInstr nstrnum SInstrName

iKeyboardModeMidi chnget SInstrName, "ASynthInput", iNum, "keyboard_mode"
iKeyboardMode round iKeyboardModeMidi

kKeyboardModeMidi chnget SInstrName, "ASynthInput", iNum, "keyboard_mode"
kKeyboardMode round kKeyboardModeMidi

iPortamentoTimeMidi chnget SInstrName, "ASynthInput", iNum, "portamento_time"
kPortamentoTime = iPortamentoTimeMidi

iPortamentoModeMidi chnget SInstrName, "ASynthInput", iNum, "portamento_mode"
kPortamentoMode round iPortamentoModeMidi

kPrevNoteChanged changed $gkUpdatePortamento

;iPrevNote chnget SInstrName, "ASynthInput", iNum, "prev_note"

if kPrevNoteChanged == 1 && kKeyboardMode == $KEY_MODE_LEGATO then
    reinit reset
endif

reset:

;print iMidiKey

SCurrentNote sprintf "%s.%s.%d.%s", SInstrName, "ASynthInput", iNum, "current_note"
iCurrentNote chnget SCurrentNote

if iCurrentNote > 0 && iKeyboardMode == $KEY_MODE_LEGATO then
    iMidiKey = iCurrentNote
endif

SPrevNote sprintf "%s.%s.%d.%s", SInstrName, "ASynthInput", iNum, "prev_note"
iMaybePrevNote chnget SPrevNote

if kKeyboardMode == $KEY_MODE_LEGATO && iMaybePrevNote != iCurrentNote then
    iPrevNote = iMaybePrevNote
endif

SString sprintf "ASynthPortamento: %s iPrevNote = %d iMidiKey = %d iCurrentNote = %d\n", SInstrName, iPrevNote, iMidiKey, iCurrentNote

kSkip init 0
if kSkip == 0 then
    kRes strToFile SString, "debug.txt", 1
    kSkip = 1
endif

;print iPrevNote, iMidiKey, iCurrentNote

kFreq mtof iMidiKey

;if iPrevNote == 0 then
;    iPrevNoteFreq = 0
;else
    iPrevNoteFreq mtof iPrevNote
;endif

;print iMidiKey
;print iPrevNote
;print iPrevNoteFreq

kInstrCount active iInstr, 0, 1

if kKeyboardMode == $KEY_MODE_POLY then
    if iPrevNoteFreq == 0 then
        kPortamentoTime = 0
    endif
    if kInstrCount <= 1 && kPortamentoMode == $PORTAMENTO_LEGATO then
        kPortamentoTime = 0
    endif
else
    if kPortamentoMode == $PORTAMENTO_LEGATO && iPrevNote == 0 then
        kPortamentoTime = 0
    endif

    if kKeyboardMode == $KEY_MODE_MONO then
        kFreq = cpsoct(octmidinn($gkLargestHeldKey))
    endif
endif

rireturn

kFreq portk kFreq, 0.2 * kPortamentoTime, iPrevNoteFreq

xout kFreq
endop


opcode ASynthLfoFreq, k, Sika
SInstrName, iNum, kFreq, aLfo xin

kLfoToOscMidi chnget SInstrName, "ASynthLfoFreq", iNum, "freq_mod_osc"
kLfoToOsc round kLfoToOscMidi 

kLfoFreqAmountMidi chnget SInstrName, "ASynthLfoFreq", iNum, "freq_mod_amount"
kLfoFreqAmount pow kLfoFreqAmountMidi, 3
kLfoFreqAmount = kLfoFreqAmount - 1
kLfoFreqAmount = kLfoFreqAmount / 2 + 0.5

if kLfoToOsc == 0 || kLfoToOsc == iNum then
    kOsc = kFreq * ( kLfoFreqAmount * ( aLfo + 1 ) + 1 - kLfoFreqAmount )
    kFreq min kOsc, sr / 2
endif

xout kFreq
endop


opcode ASynthRender, aa, Siaa
SInstrName, iNum, aVcoL, aVcoR xin

iInstr nstrnum SInstrName

kMasterVolMidi chnget SInstrName, "ASynthRender", iNum, "master_vol"
kMasterVol = kMasterVolMidi

kKeyboardModeMidi chnget SInstrName, "ASynthInput", iNum, "keyboard_mode"
kKeyboardMode round kKeyboardModeMidi

aClipL clip aVcoL, 0, 0.9
aClipR clip aVcoR, 0, 0.9

kInstrCount active iInstr, 0, 1

if kKeyboardMode == $KEY_MODE_POLY then
    kInstrCount active iInstr, 0, 0
    kPort linseg 0, 0.0001, 0.01, 1, 0.01
    kInstrCountScale portk kInstrCount^0.5, kPort
else
    kInstrCountScale = 1
endif

if kInstrCountScale != 0 then
    aLeft = (aClipL * kMasterVol) / kInstrCountScale
    aRight = (aClipR * kMasterVol) / kInstrCountScale
else
    aLeft init 0
    aRight init 0
endif

xout aLeft, aRight
endop


opcode ASynthMixerSend, 0, SSaa
SInstrName, SInstrMixer, aLeft, aRight xin

iInstr nstrnum SInstrName
iInstrMixer nstrnum SInstrMixer

MixerSetLevel iInstr, iInstrMixer, 0.9
MixerSend aLeft, iInstr, iInstrMixer, 0
MixerSend aRight, iInstr, iInstrMixer, 1

endop


opcode ASynth, aa, Siiiio
SInstrName, p2, p3, p4, p5, p6 xin

iDelay = p2
iDuration = p3
iChannel = p4
iMidiKey = p5
iMidiVelocity = p6

iNum = 1
kFreq mtof iMidiKey
iAmp = iMidiVelocity / 127

iInstr nstrnum SInstrName
kInstrCount active iInstr, 0, 0
;printk 1, kInstrCount, 0, 1

kPhasor phasor 1
if kPhasor == 0 then
    kLargestHeldKey GetMax gkHeldKeys, iChannel, 0
endif
;printk 1, kLargestHeldKey, 0, 1

kFreq ASynthPortamento SInstrName, 1, iMidiKey, iChannel

aLfoOsc ASynthLfo SInstrName, 1, kFreq

;extra does not exist in original amsynth
kOsc1Freq ASynthDetune SInstrName, 1, kFreq

kOsc1Freq ASynthLfoFreq SInstrName, 1, kOsc1Freq, aLfoOsc

kOsc2Freq ASynthDetune SInstrName, 2, kFreq

kOsc2Freq ASynthLfoFreq SInstrName, 2, kOsc2Freq, aLfoOsc

aNone init 0

aOsc1, aOsc1Sync ASynthOsc SInstrName, 1, iAmp, kOsc1Freq, aNone

aOsc2, aOsc2Sync ASynthOsc SInstrName, 2, iAmp, kOsc2Freq, aOsc1Sync

aVco ASynthMix SInstrName, 1, aOsc1, aOsc2

aVco ASynthAmp SInstrName, 1, aVco, aLfoOsc

aVco ASynthFilter SInstrName, 1, aVco, aLfoOsc, kFreq, iAmp

aSendL, aSendR ASynthRender SInstrName, 1, aVco, aVco

xout aSendL, aSendR
endop

maxalloc "hello", 10
prealloc "hello", 10
;maxalloc "world", 16
;prealloc "world", 16

massign 1, "hello_midi"
;massign 10, "forward"

DefineChannel "hello", "ASynthAmp", 1, "amp_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0750000029802322, 0, 2.5
DefineChannel "hello", "ASynthAmp", 1, "amp_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1.55833005905151, 0, 2.5
DefineChannel "hello", "ASynthAmp", 1, "amp_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1.0
DefineChannel "hello", "ASynthAmp", 1, "amp_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.706920027732849, 0, 2.5
DefineChannel "hello", "ASynthOsc", 1, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "hello", "ASynthFilter", 1, "filter_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.133332997560501, 0, 2.5
DefineChannel "hello", "ASynthFilter", 1, "filter_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.166666999459267, 0, 2.5
DefineChannel "hello", "ASynthFilter", 1, "filter_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0966669991612434, 0, 1.0
DefineChannel "hello", "ASynthFilter", 1, "filter_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.86666601896286, 0, 2.5
DefineChannel "hello", "ASynthFilter", 1, "filter_resonance", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.036062997579575, 0, 0.97
DefineChannel "hello", "ASynthFilter", 1, "filter_env_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1.13385999202728, -16, 16
DefineChannel "hello", "ASynthFilter", 1, "filter_cutoff", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.106298997998238, -0.5, 1.5
DefineChannel "hello", "ASynthDetune", 2, "osc_detune", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.22834600508213, -1, 1
DefineChannel "hello", "ASynthOsc", 2, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "hello", "ASynthRender", 1, "master_vol", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.692900002002716, 0, 1
DefineChannel "hello", "ASynthLfo", 1, "lfo_freq", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0, 0, 7.5
DefineChannel "hello", "ASynthLfo", 1, "lfo_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 6.0
DefineChannel "hello", "ASynthDetune", 2, "osc_range", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, -3, 4
DefineChannel "hello", "ASynthMix", 1, "osc_mix", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.244093999266624, -1, 1
DefineChannel "hello", "ASynthLfoFreq", 1, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "hello", "ASynthLfoFreq", 2, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "hello", "ASynthFilter", 1, "filter_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -1, -1, 1
DefineChannel "hello", "ASynthAmp", 1, "amp_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -1, -1, 1
DefineChannel "hello", "ASynthMix", 1, "osc_mix_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "hello", "ASynthOsc", 1, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.629921019077301, 0, 1.0
DefineChannel "hello", "ASynthOsc", 2, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.173227995634079, 0, 1.0
DefineChannel "hello", "ASynthReverb", 1, "reverb_roomsize", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.206667006015778, 0, 1
DefineChannel "hello", "ASynthReverb", 1, "reverb_damp", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "hello", "ASynthReverb", 1, "reverb_wet", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0799999982118607, 0, 1
DefineChannel "hello", "ASynthReverb", 1, "reverb_width", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1
DefineChannel "hello", "ASynthOverDrive", 1, "distortion_crunch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 0.9
DefineChannel "hello", "ASynthOsc", 1, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
DefineChannel "hello", "ASynthOsc", 2, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1
DefineChannel "hello", "ASynthInput", 1, "portamento_time", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.5, 0, 1
DefineChannel "hello", "ASynthInput", 1, "keyboard_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 2
DefineChannel "hello", "ASynthDetune", 2, "osc_pitch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, -1, -12, 12
DefineChannel "hello", "ASynthFilter", 1, "filter_type", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 4.0
DefineChannel "hello", "ASynthLfoFreq", 1, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 2.0
DefineChannel "hello", "ASynthLfoFreq", 2, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 2.0
DefineChannel "hello", "ASynthFilter", 1, "filter_kbd_track", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.783333003520966, 0, 1
DefineChannel "hello", "ASynthInput", 1, "portamento_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1

DefineChannel "world", "ASynthAmp", 1, "amp_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.960411012172699, 0, 2.5
DefineChannel "world", "ASynthAmp", 1, "amp_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0199999995529652, 0, 2.5
DefineChannel "world", "ASynthAmp", 1, "amp_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1.0
DefineChannel "world", "ASynthAmp", 1, "amp_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1, 0, 2.5
DefineChannel "world", "ASynthOsc", 1, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "world", "ASynthFilter", 1, "filter_attack", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.019556999206543, 0, 2.5
DefineChannel "world", "ASynthFilter", 1, "filter_decay", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0199999995529652, 0, 2.5
DefineChannel "world", "ASynthFilter", 1, "filter_sustain", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 1, 1.0
DefineChannel "world", "ASynthFilter", 1, "filter_release", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 1.050950050354, 0, 2.5
DefineChannel "world", "ASynthFilter", 1, "filter_resonance", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.194335973262787, 0, 0.97
DefineChannel "world", "ASynthFilter", 1, "filter_env_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, -16, 16
DefineChannel "world", "ASynthFilter", 1, "filter_cutoff", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.851123988628387, -0.5, 1.5
DefineChannel "world", "ASynthDetune", 2, "osc_detune", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 0.0118990000337362, -1, 1
DefineChannel "world", "ASynthOsc", 2, "osc_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 2, 0, 4.0
DefineChannel "world", "ASynthRender", 1, "master_vol", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.955268025398254, 0, 1
DefineChannel "world", "ASynthLfo", 1, "lfo_freq", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_EXPONENTIAL, 2.38652992248535, 0, 7.5
DefineChannel "world", "ASynthLfo", 1, "lfo_waveform", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 6.0
DefineChannel "world", "ASynthDetune", 2, "osc_range", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, -3, 4
DefineChannel "world", "ASynthMix", 1, "osc_mix", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0127280000597239, -1, 1
DefineChannel "world", "ASynthLfoFreq", 1, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "world", "ASynthLfoFreq", 2, "freq_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1.25992105
DefineChannel "world", "ASynthFilter", 1, "filter_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.863150000572205, -1, 1
DefineChannel "world", "ASynthAmp", 1, "amp_mod_amount", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, -0.993574976921082, -1, 1
DefineChannel "world", "ASynthMix", 1, "osc_mix_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "world", "ASynthOsc", 1, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.788778007030487, 0, 1.0
DefineChannel "world", "ASynthOsc", 2, "osc_pulsewidth", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.829999983310699, 0, 1.0
DefineChannel "world", "ASynthReverb", 1, "reverb_roomsize", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.675502002239227, 0, 1
DefineChannel "world", "ASynthReverb", 1, "reverb_damp", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.00193100003525615, 0, 1
DefineChannel "world", "ASynthReverb", 1, "reverb_wet", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.0824249982833862, 0, 1
DefineChannel "world", "ASynthReverb", 1, "reverb_width", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0.477634012699127, 0, 1
DefineChannel "world", "ASynthOverDrive", 1, "distortion_crunch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 0.9
DefineChannel "world", "ASynthOsc", 1, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1
DefineChannel "world", "ASynthOsc", 2, "osc_sync", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 1
DefineChannel "world", "ASynthInput", 1, "portamento_time", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 0, 0, 1
DefineChannel "world", "ASynthInput", 1, "keyboard_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2
DefineChannel "world", "ASynthDetune", 2, "osc_pitch", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, -12, 12
DefineChannel "world", "ASynthFilter", 1, "filter_type", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 4.0
DefineChannel "world", "ASynthLfoFreq", 1, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "world", "ASynthLfoFreq", 2, "freq_mod_osc", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 0, 0, 2.0
DefineChannel "world", "ASynthFilter", 1, "filter_kbd_track", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_LINEAR, 1, 0, 1
DefineChannel "world", "ASynthInput", 1, "portamento_mode", $CHANNEL_MODE_INPUT, $CHANNEL_TYPE_INTEGER, 1, 0, 1

instr 2

kcps = 110
ifn  = 1

knh    line p4, p3, p5
asig    buzz 1, kcps, knh, ifn
    outs asig, asig
endin

instr sine
    SInstrName = "sine"
    iNum = 1
    iMidiKey = p4
    iMidiVelocity = p5

    iFreq mtof iMidiKey
    iAmp = iMidiVelocity / 127


    ;print iAmp, iFreq

    aSync init 0
    iPhase = 0
    asig oscilikts iAmp, iFreq, 1, aSync, iPhase
    asig oscils iAmp, iFreq, 0

    chnset 1, SInstrName, "ASynthRender", iNum, "master_vol"
    chnset 0, SInstrName, "ASynthInput", iNum, "keyboard_mode"

    aSendL, aSendR ASynthRender SInstrName, 1, asig, asig
    outs aSendL, aSendR
endin

instr forward
    iMidiKey = p4
    iMidiVelocity = p5

    kStatus GetMidiStatus

    iInstr nstrnum "hello_midi"
    iChannel = 1
    iInstrnum = iInstr + iChannel / 100.0 + iMidiKey / 100000.0;

    iInstr2 nstrnum "world_midi"
    iInstrnum2 = iInstr2 + iChannel / 100.0 + iMidiKey / 100000.0;

    if kStatus == $MIDI_NOTE_ON then
        event "i", iInstrnum, 0, -1, iChannel, iMidiKey, iMidiVelocity
        event "i", iInstrnum2, 0, -1, iChannel, iMidiKey, iMidiVelocity
    elseif kStatus == $MIDI_NOTE_OFF then
        event "i", -iInstrnum, 0, 0, iChannel, iMidiKey, iMidiVelocity
        event "i", -iInstrnum2, 0, 0, iChannel, iMidiKey, iMidiVelocity
    endif
endin

instr hello
    SInstrName = "hello"
    SInstrMixer = "hello_mixer"
    ;prints "%s = %f\n", "p1 =", p1
    ;prints "%s = %f\n", "p6 =", p6
    ;print p1, p2, p3, p4, p5, p6
    aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6
    ASynthMixerSend SInstrName, SInstrMixer, aSendL, aSendR
endin

instr hello_midi
    iHelloMidi = p1
    SInstrName = "hello"
    iChannel = p4
    iMidiKey = p5
    iMidiVelocity = p6

	kSkip init 0
	if kSkip == 0 then
    	;print p1, p2, p3, p4, p5, p6
    	ASynthInput SInstrName, iChannel, iMidiKey, iMidiVelocity
		kSkip = 1
	endif

	kRelease release
	if kRelease=1 then
    	;print p1, p2, p3, p4, p5, p6
    	ASynthInput SInstrName, iChannel, iMidiKey, 0
	endif
    ;turnoff
endin

instr hello_mixer
    SInstrName = "hello"
    SInstrMixer = "hello_mixer"
    ASynthEffects SInstrName, SInstrMixer
endin

instr world
    SInstrName = "world"
    SInstrMixer = "world_mixer"
    aSendL, aSendR ASynth SInstrName, p2, p3, p4, p5, p6
    ASynthMixerSend SInstrName, SInstrMixer, aSendL, aSendR
endin

instr world_midi
    SInstrName = "world"
    iChannel = p4
    iMidiKey = p5
    iMidiVelocity = p6

    ASynthInput SInstrName, iChannel, iMidiKey, iMidiVelocity
endin

instr world_mixer
    SInstrName = "world"
    SInstrMixer = "world_mixer"
    ASynthEffects SInstrName, SInstrMixer
endin

instr write_to_file
    ;SString = "Hello there, my name is Werner"
    ;iRes strToFile SString, "string.txt", 1
    ;if iRes == 1 then
    ;    prints "Success, file was written"
    ;else
    ;    prints "Failed to write file"
    ;endif
endin

instr 10000
    MixerClear
endin

</CsInstruments>
<CsScore>
f 1 0 16384 10 1 ;sine
f 0 3600
i "hello_mixer" 0 -1
i "world_mixer" 0 -1
i 10000 0 -1

i "write_to_file" 0, 1

i 2 0 1 20 20
i 2 + 3 3 3
i 2 + 3 10 1

;i "forward" 0 1 60 30
;i "forward" + 1 62 <
;i "forward" + 1 65 <
;i "forward" + 1 69 10
;
;i "forward" 5 1 60 30
;i "forward" + 1 62 <
;i "forward" 7 1 65 <
;i "forward" 7 1 69 10


</CsScore>
</CsoundSynthesizer>
