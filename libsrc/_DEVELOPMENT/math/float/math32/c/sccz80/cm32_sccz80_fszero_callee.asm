

SECTION code_fp_math32

PUBLIC cm32_sccz80_fszero_callee

EXTERN m32_fszero_fastcall

    ; return a legal zero
    ;
    ; enter : stack = ret
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC  cm32_sccz80_fszero_callee = m32_fszero_fastcall   ; enter stack = ret
                                                        ;        DEHL = d32_float
                                                        ; return DEHL = d32_float
