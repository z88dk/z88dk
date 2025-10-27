
; float __zero (float number)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_zero

EXTERN cam32_sdcc_read1, asm_am9511_zero

.cam32_sdcc_zero

    ; return a signed legal zero
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(signed 0)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_read1

    jp asm_am9511_zero      ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
