
; float __fsmax_callee (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsmax_callee

EXTERN md32_fsmax_fastcall

    ; convert sdcc float to infinity with correct sign
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(infinity)
    ;
    ; uses  : af, bc, de, hl

DEFC  cd32_sccz80_dsmax_callee = md32_fsmax_fastcall    ; enter stack = ret
                                                        ;        DEHL = d32_float
                                                        ; return DEHL = d32_float
