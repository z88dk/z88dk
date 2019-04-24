
; float __fsadd (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsadd

EXTERN cd32_sdcc_dread2, md32_fsadd, cd32_sdcc_dret

.cd32_sdcc_dsadd

    ; add two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dread2

    call md32_fsadd         ; enter stack = sdcc_float right, sdcc_float left, ret, d32_float left
                            ;        BCDE = d32_float right
                            ; return BCDE = d32_float

    pop af                  ; discard d32_float left
    pop af

    jp cd32_sdcc_dret       ; return DEHL = sdcc_float

