

SECTION code_fp_math32
PUBLIC cm32_sccz80_acos

EXTERN cm32_sccz80_fsread1, _m32_acosf

cm32_sccz80_acos:
    call cm32_sccz80_fsread1
    jp _m32_acosf
