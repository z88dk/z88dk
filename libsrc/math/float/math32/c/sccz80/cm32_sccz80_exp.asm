

SECTION code_fp_math32
PUBLIC cm32_sccz80_exp

EXTERN cm32_sccz80_fsread1, _m32_expf

cm32_sccz80_exp:
    call cm32_sccz80_fsread1
    jp _m32_expf
