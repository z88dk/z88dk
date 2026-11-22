

SECTION code_fp_math32
PUBLIC cm32_sccz80_asin

EXTERN cm32_sccz80_fsread1, _m32_asinf

cm32_sccz80_asin:
    call cm32_sccz80_fsread1
    jp _m32_asinf
