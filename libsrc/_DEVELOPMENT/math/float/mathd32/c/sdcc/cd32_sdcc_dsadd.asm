
; float __fsadd (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsadd

EXTERN cd32_sdcc_dreadr, md32_fsadd

.cd32_sdcc_dsadd

    ; add two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadr

    jp md32_fsadd           ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
