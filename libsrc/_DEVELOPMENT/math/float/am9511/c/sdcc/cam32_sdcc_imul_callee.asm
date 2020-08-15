
; int __imul_callee (int left, int right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC _am9511_imul_callee
PUBLIC cam32_sdcc_imul_callee

EXTERN cam32_sdcc_ireadr_callee, asm_am9511_imul_callee

DEFC _am9511_imul_callee = cam32_sdcc_imul_callee

.cam32_sdcc_imul_callee

    ; multiply two sdcc ints
    ;
    ; enter : stack = sdcc_int right, sdcc_int left, ret
    ;
    ; exit  : DEHL = sdcc_int(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_ireadr_callee
    jp asm_am9511_imul_callee   ; enter stack = sdcc_int left, ret
                                ;        DEHL = sdcc_int right
                                ; return DEHL = sdcc_int
