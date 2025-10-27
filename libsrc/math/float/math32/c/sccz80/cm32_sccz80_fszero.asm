

SECTION code_fp_math32

PUBLIC cm32_sccz80_fszero

EXTERN m32_fszero

    ; return a signed legal zero
    ;
    ; enter : stack = ret, DEHL = signed d32_float
    ;
    ; exit  :  DEHL = sccz80_float(signed 0 d32_float)
    ;
    ; uses  : af, bc, de, hl

DEFC  cm32_sccz80_fszero = m32_fszero           ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
