<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

instr 1

iAmp = .7
iFreq = 220
aSync init 0
iPhase = 0
iflg = p4
asig oscils iAmp, iFreq, iPhase, iflg

ksig = k(asig)
printk 0.07, ksig
     outs asig, asig
endin


instr 2

iAmp = .7
iFreq = 220
aSync init 0
kPhase phasor iFreq / 4
iflg = p4
kFun = 1

asig oscilikts iAmp, iFreq, kFun, aSync, kPhase

ksig = k(asig)
printk 0.07, ksig
     outs asig, asig
endin


instr 3

iTable = 1
iSize = 16384

iIndex = 0

aNdx lfo iSize, 200, 1
aRead table aNdx, iTable

kRead = k(aRead)
printk 0.07, kRead

outs aRead * 0.2 , aRead * 0.2

endin



</CsInstruments>
<CsScore>
f 1 0 16384 10 1 ;sine
i 1 0 2 0
i 1 3 2 2
i 2 6 2 0
i 2 9 2 2
e
</CsScore>
</CsoundSynthesizer>
