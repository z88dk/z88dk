
; float __fsinv (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fsinv

EXTERN m32_fsinv_fastcall

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cm32_sccz80_fsinv = m32_fsinv_fastcall    ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
