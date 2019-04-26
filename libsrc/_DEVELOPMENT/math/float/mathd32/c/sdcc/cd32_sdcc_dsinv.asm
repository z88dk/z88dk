
; float __fsinv (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsinv

EXTERN cd32_sdcc_dreadl, md32_fsinv, cd32_sdcc_dret

.cd32_sdcc_dsinv

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadl

    jp md32_fsinv           ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
