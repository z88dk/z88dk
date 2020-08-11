
    SECTION code_fp_am9511
    PUBLIC  l_f32_ne
    EXTERN  asm_am9511_compare_callee


.l_f32_ne
    call asm_am9511_compare_callee
    scf
    ret NZ
    ccf
    dec hl
    ret
