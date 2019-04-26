
; float __fsdiv (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsdiv

EXTERN cd32_sdcc_dreadr, md32_fsdiv, cd32_sdcc_dret

.cd32_sdcc_dsdiv

    ; divide sdcc float by sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadr

    jp md32_fsdiv           ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
