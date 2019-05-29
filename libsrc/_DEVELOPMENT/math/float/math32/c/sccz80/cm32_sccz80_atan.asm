

SECTION code_fp_math32
PUBLIC cm32_sccz80_atan

EXTERN cm32_sccz80_fsread1, _m32_atanf

cm32_sccz80_atan:
    call cm32_sccz80_fsread1
    jp _m32_atanf
