
; float __fsinv_callee (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fsinv_callee

EXTERN m32_fsinv_fastcall

    ; invert sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cm32_sccz80_fsinv_callee = m32_fsinv_fastcall     ; enter stack = ret
                                                        ;        DEHL = d32_float
                                                        ; return DEHL = d32_float
