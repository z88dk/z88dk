

SECTION code_fp_math32
PUBLIC cm32_sccz80_fpclassify

EXTERN cm32_sccz80_fsread1, _m32_fpclassify

cm32_sccz80_fpclassify:
    call cm32_sccz80_fsread1
    jp _m32_fpclassify
