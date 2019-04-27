
; float __fsmul (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsmul

EXTERN cd32_sdcc_dreadr, md32_fsmul

.cd32_sdcc_dsmul

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadr

    jp md32_fsmul           ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
