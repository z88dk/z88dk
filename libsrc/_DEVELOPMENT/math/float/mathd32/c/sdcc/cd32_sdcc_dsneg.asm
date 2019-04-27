
; float __fsneg (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsneg

EXTERN cd32_sdcc_dreadl, md32_fsneg

.cd32_sdcc_dsneg

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sdcc_dreadl

    jp md32_fsneg           ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
