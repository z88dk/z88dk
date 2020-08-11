
    SECTION code_fp_am9511
    PUBLIC  l_f32_lt
    EXTERN  asm_am9511_compare_callee


.l_f32_lt
    call asm_am9511_compare_callee
    ret C
    dec hl
    ret
