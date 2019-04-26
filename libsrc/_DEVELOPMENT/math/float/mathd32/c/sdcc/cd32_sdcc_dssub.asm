
; float __fsadd (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dssub

EXTERN cd32_sdcc_dreadr, md32_fssub, cd32_sdcc_dret

.cd32_sdcc_dssub

    ; subtract sdcc float from sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadr

    jp md32_fssub           ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float

