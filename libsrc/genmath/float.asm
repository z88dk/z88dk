;       Generic Z80 Floating point routines
;       For Small C+ compiler



                XLIB     float

                XDEF    float1
                XREF    fasign
                XREF    fa
                XREF    norm    ;in lib/float.asm

;
;       convert the integer in hl to
;       a floating point number in FA
;
;       This routine will need to be rewritten slightly to handle
;       long ints..hopefully fairly OKish..

.float  LD      A,H     ;fetch MSB
.float1
        CPL             ;reverse sign bit
        LD      (FASIGN),A ;save sign (msb)
        RLA             ;move sign into cy
        JR      C,FL4   ;c => nonnegative number
        EX      DE,HL
        SBC     HL,HL   ;clear hl
        SBC     HL,DE   ;get positive number into hl
.FL4    LD      A,L
        DEFB    $DD
        LD      H,A     ;move LSB to hx
        LD      C,H     ;move MSB to c
        LD      DE,0    ;clear rest of registers
        LD      B,D
        DEFB    $DD
        LD      L,D     ;clear lx
        LD      A,16+128
        LD      (FA+5),A ;preset exponent
        JP      NORM    ;go normalize c ix de b

