
    SECTION code_fp_math16
    PUBLIC  l_f16_le
    EXTERN  asm_f16_compare_callee


.l_f16_le
    call asm_f16_compare_callee
    ret C
    scf
    ret Z
    ccf
    dec hl
    ret
