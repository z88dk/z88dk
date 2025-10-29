

SECTION code_fp_math32
PUBLIC cm32_sccz80_asinh

EXTERN cm32_sccz80_fsread1, _m32_asinhf

cm32_sccz80_asinh:
    call cm32_sccz80_fsread1
    jp _m32_asinhf
