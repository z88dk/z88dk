
; float __fsinvsqrt (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsinvsqrt

EXTERN md32_fsinvsqrt

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cd32_sccz80_dsinvsqrt = md32_fsinvsqrt    ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
