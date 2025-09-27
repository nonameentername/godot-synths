<CoundSynthesizer>
<CsOptions>
-+rtmidi=NULL -M0 --midi-key=5 --midi-velocity=6 -n
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

massign 0, 0

#include "amsynth_common.inc"

#define INSTRUMENT_NAME #eleven#
#define INSTRUMENT_CHANNEL #11#

#include "amsynth_instr.inc"

#define INSTRUMENT_NAME #twelve#
#define INSTRUMENT_CHANNEL #12#

#include "amsynth_instr.inc"


</CsInstruments>
<CsScore>
f 1 0 16384 10 1 ;sine
f 0 z
i "eleven_mixer" 0 -1
i "twelve_mixer" 0 -1

</CsScore>
</CsoundSynthesizer>
