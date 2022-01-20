
; float __fmul (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_fmul

EXTERN asm_sdcc_readr, asm_am9511_fmul

.cam32_sdcc_fmul

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr
    jp asm_am9511_fmul      ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
