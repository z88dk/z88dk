

SECTION code_fp_math32
PUBLIC cm32_sccz80_round

EXTERN cm32_sccz80_fsread1, _m32_roundf

cm32_sccz80_round:
    call cm32_sccz80_fsread1
    jp _m32_roundf
