

SECTION code_fp_am9511
PUBLIC cam32_sccz80_zero

EXTERN asm_am9511_zero

    ; return a signed legal zero
    ;
    ; enter : stack = ret, DEHL = signed IEEE_float
    ;
    ; exit  :  DEHL = sccz80_float(signed 0 IEEE_float)
    ;
    ; uses  : af, bc, de, hl

DEFC  cam32_sccz80_zero = asm_am9511_zero       ; enter stack = ret
                                                ;        DEHL = IEEE_float
                                                ; return DEHL = IEEE_float
