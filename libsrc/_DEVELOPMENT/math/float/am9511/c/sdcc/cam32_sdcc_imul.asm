
; int __imul (int left, int right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_imul

EXTERN cam32_sdcc_ireadr, asm_am9511_imul

.cam32_sdcc_imul

    ; multiply two sdcc ints
    ;
    ; enter : stack = sdcc_int right, sdcc_int left, ret
    ;
    ; exit  : DEHL = sdcc_int(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_ireadr
    jp asm_am9511_imul      ; enter stack = sdcc_int right, sdcc_int left, ret
                            ;        DEHL = sdcc_int right
                            ; return DEHL = sdcc_int
