
; float __fssqr (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fssqr

EXTERN m32_fssqr_fastcall

    ; square (^2) sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

DEFC  cm32_sccz80_fssqr = m32_fssqr_fastcall    ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
