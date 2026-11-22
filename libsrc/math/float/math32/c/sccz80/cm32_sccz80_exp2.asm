

SECTION code_fp_math32
PUBLIC cm32_sccz80_exp2

EXTERN cm32_sccz80_fsread1, _m32_exp2f

cm32_sccz80_exp2:
    call cm32_sccz80_fsread1
    jp _m32_exp2f
