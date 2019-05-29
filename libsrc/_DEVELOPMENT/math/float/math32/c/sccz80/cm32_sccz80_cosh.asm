

SECTION code_fp_math32
PUBLIC cm32_sccz80_cosh

EXTERN cm32_sccz80_fsread1, _m32_coshf

cm32_sccz80_cosh:
    call cm32_sccz80_fsread1
    jp _m32_coshf
