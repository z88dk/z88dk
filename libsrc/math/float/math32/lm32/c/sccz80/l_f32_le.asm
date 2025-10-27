
    SECTION code_fp_math32
    PUBLIC  l_f32_le
    EXTERN  m32_compare_callee


.l_f32_le
    call m32_compare_callee
    ret C
    scf
    ret Z
    ccf
    dec hl
    ret
