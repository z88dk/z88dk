

SECTION code_fp_math32
PUBLIC cm32_sccz80_sin

EXTERN cm32_sccz80_fsread1, _m32_sinf

cm32_sccz80_sin:
    call cm32_sccz80_fsread1
    jp _m32_sinf
