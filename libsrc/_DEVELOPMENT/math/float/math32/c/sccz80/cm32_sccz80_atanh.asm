

SECTION code_fp_math32
PUBLIC cm32_sccz80_atanh

EXTERN cm32_sccz80_fsread1, _m32_atanhf

cm32_sccz80_atanh:
    call cm32_sccz80_fsread1
    jp _m32_atanhf
