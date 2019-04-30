
; float __fsadd_callee (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dssub_callee

EXTERN cd32_sdcc_dreadr_callee, md32_fssub_callee

.cd32_sdcc_dssub_callee

    ; subtract sdcc float from sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadr_callee

    jp md32_fssub_callee    ; enter stack = sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
