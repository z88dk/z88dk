
; float __fshypot (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fshypot

EXTERN m32_fshypot

    ; find the hypotenuse of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cm32_sccz80_fshypot = m32_fshypot ; enter stack = d32_float left
                                        ;        DEHL = d32_float right
                                        ; return DEHL = d32_float
