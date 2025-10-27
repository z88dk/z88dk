
    SECTION code_fp_math16
    PUBLIC  l_f16_gt
    EXTERN  asm_f16_compare_callee


.l_f16_gt
    call asm_f16_compare_callee
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret
