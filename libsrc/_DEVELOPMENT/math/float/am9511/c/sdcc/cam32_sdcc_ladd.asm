
; long __ladd (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_ladd

EXTERN asm_sdcc_readr, asm_am9511_ladd

.cam32_sdcc_ladd

    ; add two sdcc longs
    ;
    ; enter : stack = sdcc_long right, sdcc_long left, ret
    ;
    ; exit  : DEHL = sdcc_long(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr
    jp asm_am9511_ladd      ; enter stack = sdcc_long right, sdcc_long left, ret
                            ;        DEHL = sdcc_long right
                            ; return DEHL = sdcc_long
