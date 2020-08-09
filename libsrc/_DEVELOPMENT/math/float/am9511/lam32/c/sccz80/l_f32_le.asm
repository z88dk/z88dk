
    SECTION code_fp_am9511
    PUBLIC  l_f32_le
    EXTERN  asm_am9511_compare_callee


.l_f32_le
    call asm_am9511_compare_callee
    ret C
    scf
    ret Z
    ccf
    dec hl
    ret
