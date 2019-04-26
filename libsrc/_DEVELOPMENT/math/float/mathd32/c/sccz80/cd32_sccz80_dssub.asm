
; float __fssub (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dssub

EXTERN md32_fssub

    ; subtract sccz80 float from sccz80 float
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cd32_sccz80_dssub = md32_fssub    ; enter stack = d32_float left
                                        ;        DEHL = d32_float right
                                        ; return DEHL = d32_float
