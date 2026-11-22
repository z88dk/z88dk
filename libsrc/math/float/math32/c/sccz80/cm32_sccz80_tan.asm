

SECTION code_fp_math32
PUBLIC cm32_sccz80_tan

EXTERN cm32_sccz80_fsread1, _m32_tanf

cm32_sccz80_tan:
    call cm32_sccz80_fsread1
    jp _m32_tanf
