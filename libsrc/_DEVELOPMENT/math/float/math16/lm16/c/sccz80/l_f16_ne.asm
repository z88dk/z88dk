
    SECTION code_fp_math16
    PUBLIC  l_f16_ne
    EXTERN  asm_f16_compare_callee


.l_f16_ne
    call asm_f16_compare_callee
    scf
    ret NZ
    ccf
    dec hl
    ret
