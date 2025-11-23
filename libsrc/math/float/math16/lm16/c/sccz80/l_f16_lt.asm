
    SECTION code_fp_math16
    PUBLIC  l_f16_lt
    EXTERN  asm_f16_compare_callee


.l_f16_lt
    call asm_f16_compare_callee
    ret C
    dec hl
    ret
