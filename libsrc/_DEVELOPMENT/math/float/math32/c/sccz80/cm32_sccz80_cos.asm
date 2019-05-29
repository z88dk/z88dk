

SECTION code_fp_math32
PUBLIC cm32_sccz80_cos

EXTERN cm32_sccz80_fsread1, _m32_cosf

cm32_sccz80_cos:
    call cm32_sccz80_fsread1
    jp _m32_cosf
