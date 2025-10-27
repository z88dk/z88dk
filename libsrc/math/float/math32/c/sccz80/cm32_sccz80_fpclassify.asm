

SECTION code_fp_math32
PUBLIC cm32_sccz80_fpclassify

EXTERN cm32_sccz80_fsread1, m32_fpclassify

cm32_sccz80_fpclassify:
    call cm32_sccz80_fsread1
    call m32_fpclassify
    ld l,a
    ld h,0
    ret
