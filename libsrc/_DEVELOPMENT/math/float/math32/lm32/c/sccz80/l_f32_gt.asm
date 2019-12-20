
    SECTION code_fp_math32
    PUBLIC  l_f32_gt
    EXTERN  m32_compare_callee


.l_f32_gt
    call m32_compare_callee
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret
