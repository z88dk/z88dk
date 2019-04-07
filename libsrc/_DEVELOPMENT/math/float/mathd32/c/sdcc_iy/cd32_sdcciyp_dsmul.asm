
; float __fsmul (float a1, float a2)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcciyp_dsmul

EXTERN cd32_sdcciyp_dread2, md32_mul, cd32_sdcciyp_d322d

.cd32_sdcciyp_dsmul

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float a2, sdcc_float a1, ret
    ;
    ; exit  : DEHL = sdcc_float(a1*a2)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sdcciyp_dread2

    call md32_mul           ; enter stack = sdcc_float right, sdcc_float left, ret, d32_float left
                            ;        BCDE = d32_float right
                            ; return BCDE = d32_float

    pop af                  ; discard d32_float left
    pop af

    jp cd32_sdcciyp_d322d   ; return DEHL = sdcc_float

