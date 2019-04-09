
; float __fsmul (float a1, float a2)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsmul

EXTERN cd32_sdcc_dread2, md32_fsmul, cd32_sdcc_dret

.cd32_sdcc_dsmul

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float a2, sdcc_float a1, ret
    ;
    ; exit  : DEHL = sdcc_float(a1*a2)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sdcc_dread2

    call md32_fsmul         ; enter stack = sdcc_float right, sdcc_float left, ret, d32_float left
                            ;        BCDE = d32_float right
                            ; return BCDE = d32_float

    pop af                  ; discard d32_float left
    pop af

    jp cd32_sdcc_dret       ; return DEHL = sdcc_float

