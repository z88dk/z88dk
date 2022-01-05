
IF __CPU_Z80__ | __CPU_Z80N__
    SECTION smc_clib
    PUBLIC  asm_saa_ay_play

    INCLUDE "ports.def"

;the outputs to the AY-3-8912’s registers are intercepted and
;are used as memory mapped i/o


DEFVARS 0 {
    ayfine1     ds.b    1
    aycoarse1   ds.b    1
    ayfine2     ds.b    1
    aycoarse2   ds.b    1
    ayfine3     ds.b    1
    aycoarse3   ds.b    1
    aynoisepitch    ds.b    1
    aymixer     ds.b     1
    ayvol1      ds.b     1
    ayvol2      ds.b     1
    ayvol3      ds.b     1
    ayenvlen    ds.b     1
    ayenvlen2   ds.b     1
    ayenvshapre ds.b     1
}



; Entry: ix = memory mapped ay registers
asm_saa_ay_play:
    LD      l,(ix+ayfine1) ;ayfine1
    LD      A,(ix+aycoarse1) ;aycoarse1
    AND     15
    LD      h,a
    add     hl,hl
    ld      de,pitchconvert
    add     hl,de
    ld      a,(hl)
    ld      (saatone2),a
    inc     l
    ld      a,(hl)
    ld      (stoctave1+1),a
    ld      l,(ix+ayfine2)
    ld      a,(ix+aycoarse1)
    and     15
    ld      h,a
    add     hl,hl
    ld      de,pitchconvert
    add     hl,de
    ld      a,(hl)
    ld      (saatone3),a
    inc     hl
    ld      a,(hl)
    rlca
    rlca
    rlca
    rlca
stoctave1:
    or      a
    LD      (saaoct32),A

    ld      l,(ix+ayfine3)
    ld      a,(ix+aycoarse3)
    and     15
    ld      h,a
    add     hl,hl
    ld      de,pitchconvert
    add     hl,de
    ld      a,(hl)
    ld      (saatone5),a
    inc     hl
    ld      a,(hl)
    rlca
    rlca
    rlca
    rlca
    ld      (saaoct54),a

    ld      l,(ix+aynoisepitch)
    ld      h,0
    ld      de,noiseconvert
    add     hl,de
    ld      a,(hl)
    ld      (saanoisefreq),a

    ld      a,(ix+aymixer)
    ld      de,0
    bit     0,a
    jr      nz,c2nsound
    set     2,d
c2nsound:
    bit     3,a
    jr      nz,c2nnoise
    SET     2,E
c2nnoise: 
    BIT     1,A
    JR      NZ,c3nsound
    SET     3,D
c3nsound: 
    BIT     4,A
    JR      NZ,c3nnoise
    SET     3,E
c3nnoise: 
    BIT     2,A
    JR      NZ,c5nsound
    SET     5,D
c5nsound: 
    BIT     5,A
    JR      NZ,c5nnoise
    SET     5,E
c5nnoise:
    LD      A,D
    LD      (saafreqen),A
    LD      A,E
    LD      (saanoiseen),A

    LD      a,(ix+ayvol1)
    rlca
    rlca
    rlca
    rlca
    or      (ix+ayvol1)
    ld      (saaamp2),a

    LD      a,(ix+ayvol2)
    rlca
    rlca
    rlca
    rlca
    or      (ix+ayvol2)
    ld      (saaamp3),a

    LD      a,(ix+ayvol3)
    rlca
    rlca
    rlca
    rlca
    or      (ix+ayvol3)
    ld      (saaamp5),a
    
playit:

    LD      BC,port_sound_data
    LD      HL,saaouts
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    OUTI
    RET

amp0: EQU 0
amp1: EQU 1
amp2: EQU 2
amp3: EQU 3
amp4: EQU 4
amp5: EQU 5

tone0: EQU 8
tone1: EQU 9
tone2: EQU 10
tone3: EQU 11
tone4: EQU 12
tone5: EQU 13

oct10: EQU 16
oct32: EQU 17
oct54: EQU 18

freqen: EQU 20
noiseen: EQU 21
noisefreq: EQU 22

env0: EQU 24
env1: EQU 25

onoff: EQU 28



    SECTION data_psg

; SAA output registers
saaouts:    DEFB tone2
saatone2:   DEFB 0
            DEFB amp2
saaamp2:    DEFB 0
            DEFB tone3
saatone3:   DEFB 0
            DEFB amp3
saaamp3:    DEFB 0
            DEFB oct32
saaoct32:   DEFB 0
            DEFB tone5
saatone5:   DEFB 0
            DEFB amp5
saaamp5:    DEFB 0
            DEFB oct54
saaoct54:   DEFB 0
            DEFB noisefreq
saanoisefreq: DEFB 0
            DEFB freqen
saafreqen:  DEFB 0
            DEFB noiseen
saanoiseen: DEFB 0
            DEFB onoff
            DEFB 1


SECTION rodata_psg
noiseconvert: 
    DEFB 0,0,0,0,0,0,17,17,17,17,17,17,17,17,17,17,34
    DEFB 34,34,34,34,34,34,34,34,34,34,34,34,34,34,34

envconvert: 
    DEFB 132,132,132,132,140,140,140,140
    DEFB 134,132,138,130,142,130,138,140

pitchconvert: 
    INCLUDE     "ayemul/pitchtable.inc"
ENDIF
