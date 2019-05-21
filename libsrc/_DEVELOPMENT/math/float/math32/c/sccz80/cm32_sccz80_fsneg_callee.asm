
; float __fsneg_callee (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fsneg_callee

EXTERN m32_fsneg_fastcall

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl

DEFC  cm32_sccz80_fsneg_callee = m32_fsneg_fastcall     ; enter stack = ret
                                                        ;        DEHL = d32_float
                                                        ; return DEHL = d32_float
