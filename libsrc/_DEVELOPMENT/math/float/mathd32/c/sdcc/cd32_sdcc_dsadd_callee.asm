
; float __fsadd_callee (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsadd_callee

EXTERN cd32_sdcc_dreadr_callee, md32_fsadd_callee

.cd32_sdcc_dsadd_callee

    ; add two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadr_callee

    jp md32_fsadd_callee    ; enter stack = sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
