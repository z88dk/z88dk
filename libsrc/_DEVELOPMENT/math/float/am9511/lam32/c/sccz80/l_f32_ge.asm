
    SECTION code_fp_am9511
    PUBLIC  l_f32_ge
    EXTERN  asm_am9511_compare_callee


.l_f32_ge
    call asm_am9511_compare_callee
    ccf
    ret C
    scf
    ret Z
    ccf
    dec hl
    ret
