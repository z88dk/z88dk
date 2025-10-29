

SECTION code_fp_math32
PUBLIC cm32_sccz80_acosh

EXTERN cm32_sccz80_fsread1, _m32_acoshf

cm32_sccz80_acosh:
    call cm32_sccz80_fsread1
    jp _m32_acoshf
