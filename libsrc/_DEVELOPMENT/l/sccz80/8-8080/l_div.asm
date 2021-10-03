
IF !__CPU_GBZ80__

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div

EXTERN l_deneg
EXTERN l_bcneg
EXTERN l_rlde
EXTERN l_cmpbcde


; HL = DE / HL, DE = DE % HL
l_div:
ccdiv:  LD      b,h
        LD      c,l
        LD      a,d
        XOR     b
        PUSH    AF
        LD      a,d
        OR     a
        CALL    M,l_deneg
        LD      a,b
        OR     a
        CALL    M,l_bcneg
        LD      a,16
        PUSH    AF
        EX      DE,HL
        LD     DE,0
ccdiv1: ADD     HL,HL
        call    l_rlde
        JP      Z,ccdiv2
        call    l_cmpbcde
        JP      M,ccdiv2
        LD      a,l
        OR     1
        LD      l,a
        LD      a,e
        sub     c
        LD      e,a
        LD      a,d
        SBC     b
        LD      d,a
ccdiv2: POP     AF
        DEC     a
        JP      Z,ccdiv3
        PUSH    AF
        JP     ccdiv1
ccdiv3: POP     AF
        RET     P
        call    l_deneg
        EX      DE,HL
        call    l_deneg
        EX      DE,HL
        ret
ENDIF
