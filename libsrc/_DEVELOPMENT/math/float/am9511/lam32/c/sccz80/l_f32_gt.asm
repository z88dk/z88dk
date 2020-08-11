
    SECTION code_fp_am9511
    PUBLIC  l_f32_gt
    EXTERN  asm_am9511_compare_callee


.l_f32_gt
    call asm_am9511_compare_callee
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret
