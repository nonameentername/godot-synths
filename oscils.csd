<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac    ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o oscils.wav -W ;;; for file output any platform
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
printk 0.001, ksig

     outs asig, asig

endin


instr 2

iAmp = .7
iFreq = 220
;aSync linseg 1, 0.2, 0, 0.2, 0, 0.1, 1
aSync init 0
kPhase phasor iFreq / 4
iflg = p4
kFun = 1

;asig oscilikt iAmp, iFreq, kFun, iPhase

asig oscilikts iAmp, iFreq, kFun, aSync, kPhase

ksig = k(asig)
printk 0.001, ksig

     outs asig, asig
   
endin


instr 3

iTable = 1
iSize = 16384

iIndex = 0

;while iIndex < iSize do
;    iValue table iIndex, iTable
;    print iValue
;    iIndex = iIndex + 1
;od

;aNdx line 0, p3 / 1000, iSize
aNdx lfo iSize, 200, 1
aRead table aNdx, iTable

kRead = k(aRead)
printk 0.001, kRead

outs aRead * 0.2 , aRead * 0.2

;iTableNumber = 1
;ftsave "table.ftsave", 1, iTableNumber

endin



</CsInstruments>
<CsScore>
f 1 0 16384 10 1 ;sine
i 1 0 2 0
i 1 3 2 2	;double precision
i 2 6 2 0
i 2 9 2 2	;double precision
;i 3 2 2 2
e
</CsScore>
</CsoundSynthesizer>
