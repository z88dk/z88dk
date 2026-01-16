
; float _fmax (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_fmax

EXTERN asm_sdcc_read1, asm_sdcc_readr, asm_am9511_compare

    ; maximum of two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : stack = sdcc_float right, sdcc_float left, ret
    ;          DEHL = sdcc_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sdcc_fmax
    call asm_am9511_compare ; compare two floats on the stack
    jp C,right
    call asm_sdcc_read1     ; enter  stack = sdcc_float right, sdcc_float left, ret
    ret                     ; return stack = sdcc_float right, sdcc_float left
                            ;         DEHL = sdcc_float max

.right
    call asm_sdcc_readr
    ret
