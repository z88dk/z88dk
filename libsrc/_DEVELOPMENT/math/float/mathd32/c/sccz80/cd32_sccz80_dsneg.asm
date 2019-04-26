
; float __fsneg (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsneg

EXTERN md32_fsneg

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl

DEFC  cd32_sccz80_dsneg = md32_fsneg    ; enter stack = ret
                                        ;        DEHL = d32_float
                                        ; return DEHL = d32_float
