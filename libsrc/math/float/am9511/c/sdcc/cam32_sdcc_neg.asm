
; float __neg (float number)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_neg

EXTERN asm_sdcc_read1, asm_am9511_neg

.cam32_sdcc_neg

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

    call asm_sdcc_read1

    jp asm_am9511_neg       ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
