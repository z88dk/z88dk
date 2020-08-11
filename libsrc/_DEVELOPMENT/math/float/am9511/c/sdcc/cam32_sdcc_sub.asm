
; float __sub (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_sub

EXTERN cam32_sdcc_readr, asm_am9511_sub

.cam32_sdcc_sub

    ; subtract sdcc float from sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_readr
    jp asm_am9511_sub       ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float

