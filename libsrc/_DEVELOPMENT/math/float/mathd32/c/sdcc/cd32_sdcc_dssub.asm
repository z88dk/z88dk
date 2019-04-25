
; float __fsadd (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dssub

EXTERN cd32_sdcc_dread2, md32_fssub, cd32_sdcc_dret

.cd32_sdcc_dssub

    ; subtract sdcc float from sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dread2

    call md32_fssub         ; enter stack = sdcc_float right, sdcc_float left, ret, d32_float left
                            ;        BCDE = d32_float right
                            ; return BCDE = d32_float

    pop af                  ; discard d32_float left
    pop af

    jp cd32_sdcc_dret       ; return DEHL = sdcc_float

