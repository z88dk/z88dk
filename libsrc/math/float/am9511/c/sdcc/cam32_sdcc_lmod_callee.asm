
; long __lmod_callee (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC _am9511_lmod_callee
PUBLIC cam32_sdcc_lmods_callee, cam32_sdcc_lmodu_callee

EXTERN asm_sdcc_readr_callee, asm_am9511_lmod_callee

DEFC _am9511_lmod_callee = cam32_sdcc_lmods_callee

.cam32_sdcc_lmods_callee

    ; modulus sdcc long by sdcc long
    ;
    ; enter : stack = sdcc_long right, sdcc_long left, ret
    ;
    ; exit  : DEHL = sdcc_long(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr_callee
    jp asm_am9511_lmod_callee   ; enter stack = sdcc_long left, ret
                                ;        DEHL = sdcc_long right
                                ; return DEHL = sdcc_long


.cam32_sdcc_lmodu_callee

    ; modulus sdcc long by sdcc long
    ;
    ; enter : stack = sdcc_long right, sdcc_long left, ret
    ;
    ; exit  : DEHL = sdcc_long(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr_callee
    res 7,d                     ; unsigned divisor
    jp asm_am9511_lmod_callee   ; enter stack = sdcc_long left, ret
                                ;        DEHL = sdcc_long right
                                ; return DEHL = sdcc_long
