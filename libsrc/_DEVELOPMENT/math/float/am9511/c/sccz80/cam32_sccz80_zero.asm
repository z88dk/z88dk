

SECTION code_fp_am9511

PUBLIC cam32_sccz80_zero

EXTERN asm_am9511_zero

    ; return a signed legal zero
    ;
    ; enter : stack = ret, DEHL = signed d32_float
    ;
    ; exit  :  DEHL = sccz80_float(signed 0 d32_float)
    ;
    ; uses  : af, bc, de, hl

DEFC  cam32_sccz80_zero = asm_am9511_zero       ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
