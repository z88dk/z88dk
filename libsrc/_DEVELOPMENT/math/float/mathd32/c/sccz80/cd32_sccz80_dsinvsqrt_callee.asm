
; float __fsinvsqrt_callee (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsinvsqrt_callee

EXTERN md32_fsinvsqrt_fastcall

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cd32_sccz80_dsinvsqrt_callee = md32_fsinvsqrt_fastcall    ; enter stack = ret
                                                                ;        DEHL = d32_float
                                                                ; return DEHL = d32_float
