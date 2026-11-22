
; long __ladd_callee (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC _am9511_ladd_callee
PUBLIC cam32_sdcc_ladd_callee

EXTERN asm_sdcc_readr_callee, asm_am9511_ladd_callee

DEFC _am9511_ladd_callee = cam32_sdcc_ladd_callee

.cam32_sdcc_ladd_callee

    ; add two sdcc longs
    ;
    ; enter : stack = sdcc_long right, sdcc_long left, ret
    ;
    ; exit  : DEHL = sdcc_long(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr_callee
    jp asm_am9511_ladd_callee   ; enter stack = sdcc_long left, ret
                                ;        DEHL = sdcc_long right
                                ; return DEHL = sdcc_long
