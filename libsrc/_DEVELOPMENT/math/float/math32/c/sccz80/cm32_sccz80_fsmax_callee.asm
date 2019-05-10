
; float __fsmax_callee (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fsmax_callee

EXTERN m32_fsmax_fastcall

    ; convert sccz80 float to infinity with correct sign
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(infinity)
    ;
    ; uses  : af, bc, de, hl

DEFC  cm32_sccz80_fsmax_callee = m32_fsmax_fastcall     ; enter stack = ret
                                                        ;        DEHL = d32_float
                                                        ; return DEHL = d32_float
