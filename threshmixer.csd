<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
;-odac           -iadc     -d     ;;;RT audio I/O
-odac           -iadc     -dm6  -+rtaudio=jack -+jack_client=threshMixer  -b 1024 -B 2048   ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o grain3.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
       	sr = 44100
	kr = 44100
	ksmps = 1
	nchnls = 4
        0dbfs = 1.0


      gkmute1 init 1
      gkmute2 init 1
      gkmute3 init 1
      gkmute4 init 1
      gkport init 0.001
      gkthresh1 init 0
      gkthresh2 init 0
      gkignore init 1
;zakinit 20,20

;massign 1,1
;turnon 1,0
;maxalloc 1,1

gimin = 0.001

FLcolor	180,200,199
FLpanel 	"Thresh Mixer",200,200
    istarttim = 0
    idropi = 666
    idur = 1
    ;ibox0  FLbox  "FM Synth (abram)", 1, 6, 12, 300, 20, 0, 0
    ;FLsetFont   7, ibox0
                
    gkamp1,    iknob1 FLknob  "AMP1", 0.001, 4, -1,1, -1, 50, 0,0
    gkamp2,    iknob2 FLknob  "AMP2", 0.001, 4, -1,1, -1, 50, 50,0
    gkamp3,    iknob3 FLknob  "AMP3", 0.001, 4, -1,1, -1, 50, 100,0
    gkamp4,    iknob4 FLknob  "KAMP", 0.001, 4, -1,1, -1, 50, 150,0
    gkthresh1,    iknobthresh1 FLknob  "Threshold1", 0.0001, 1.0, -1,1, -1, 50, 0,100
    gkthresh2,    iknobthresh2 FLknob  "Threshold2", 0.0001, 1.0, -1,1, -1, 50, 50,100
    gkport,    iknobport FLknob  "Port", 0.001, 1, -1,1, -1, 50, 100,100
    ;                                      ionioffitype
    gkignore,  iignorebutton  FLbutton  "Ignore Thresh",1,0,22,75,25,150,75,-1

    
    FLsetVal_i   0.0, iknob1
    FLsetVal_i   1.0, iknob2
    FLsetVal_i   0.0, iknob3
    FLsetVal_i   1.0, iknob4
    FLsetVal_i   0.001, iknobport
    FLsetVal_i   1.0, iignorebutton
    
FLpanel_end	;***** end of container

FLrun		;***** runs the widget thread 


      gkamp1 init 0
      gkamp2 init 1
      gkamp3 init 0
      gkamp4 init 1

      gkmute1 init 1
      gkmute2 init 1
      gkmute3 init 1
      gkmute4 init 1


        instr 2
	a1,a2,a3,a4 inq
        ka4 downsamp (gkamp4 - gimin)*a4
        kmix1_ = (gkignore > 0 || ka4 < gkthresh1 || ka4 > gkthresh2)?1:0
	kmix1	portk kmix1_,gkport
        kmix2_ = (gkignore > 0 || ka4 >= gkthresh1)?1:0
	kmix2	portk kmix2_,gkport
	; kmix3_ = (ka4 < gkthresh1 && ka4 > (-1*gkthresh2))?1:0
	; kmix3	portk kmix3_,gkport
	aa1 = a1 * kmix1 * gkmute1 * (gkamp1 - gimin) 
	aa2 = a2 * kmix2 * gkmute2 * (gkamp2 - gimin)
       	; aa3 = a3 * kmix3 * gkmute3 * (gkamp3 - gimin)
	outs aa1,aa2
        endin   

</CsInstruments>
<CsScore>
i2 0 36000
</CsScore>
</CsoundSynthesizer>
