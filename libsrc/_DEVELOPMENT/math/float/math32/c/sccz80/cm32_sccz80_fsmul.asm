
; float __fsmul (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fsmul

EXTERN m32_fsmul

    ; multiply two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cm32_sccz80_fsmul = m32_fsmul     ; enter stack = d32_float left
                                        ;        DEHL = d32_float right
                                        ; return DEHL = d32_float
