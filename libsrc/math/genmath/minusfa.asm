;       Small C+ Math Library - Support routine
;       Negate a floating point number

        SECTION code_fp
        PUBLIC    minusfa

        EXTERN    fa

.minusfa LD     HL,fa+4
        LD      A,(HL)
        XOR     $80
        LD      (HL),A
        RET



