
; float __fsinv (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsinv

EXTERN md32_fsinv

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl

DEFC  cd32_sccz80_dsinv = md32_fsinv    ; enter stack = ret
                                        ;        DEHL = d32_float
                                        ; return DEHL = d32_float
