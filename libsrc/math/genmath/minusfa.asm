;       Small C+ Math Library - Support routine
;       Negate a floating point number

                XLIB    minusfa

                XREF    fa

.MINUSFA LD     HL,FA+4
        LD      A,(HL)
        XOR     $80
        LD      (HL),A
        RET



