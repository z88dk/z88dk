
    SECTION code_fp_math32
    PUBLIC	l_f32_add
    EXTERN	cm32_sccz80_fsadd_callee

    defc l_f32_add = cm32_sccz80_fsadd_callee
