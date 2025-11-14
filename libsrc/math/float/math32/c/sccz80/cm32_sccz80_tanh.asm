

SECTION code_fp_math32
PUBLIC cm32_sccz80_tanh

EXTERN cm32_sccz80_fsread1, _m32_tanhf

cm32_sccz80_tanh:
    call cm32_sccz80_fsread1
    jp _m32_tanhf
