
; float __fsinvsqrt_callee (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fsinvsqrt_callee

EXTERN m32_fsinvsqrt_fastcall

    ; inverse square root sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cm32_sccz80_fsinvsqrt_callee = m32_fsinvsqrt_fastcall     ; enter stack = ret
                                                                ;        DEHL = d32_float
                                                                ; return DEHL = d32_float
