
    SECTION code_fp_math16
    PUBLIC  l_f16_ge
    EXTERN  asm_f16_compare_callee


.l_f16_ge
    call asm_f16_compare_callee
    ccf
    ret C
    scf
    ret Z
    ccf
    dec hl
    ret
