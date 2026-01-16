

SECTION code_fp_math32
PUBLIC cm32_sccz80_log10

EXTERN cm32_sccz80_fsread1, _m32_log10f

cm32_sccz80_log10:
    call cm32_sccz80_fsread1
    jp _m32_log10f
