
; float __fszero (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dszero

EXTERN cd32_sdcc_dreadl, md32_fszero

.cd32_sdcc_dszero

    ; return a legal zero
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(0)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadl

    jp md32_fszero          ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
