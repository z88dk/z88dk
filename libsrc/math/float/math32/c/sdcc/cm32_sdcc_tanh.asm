
SECTION code_fp_math32

PUBLIC cm32_sdcc_tanh

EXTERN cm32_sdcc_fsread1, _m32_tanhf

cm32_sdcc_tanh:
    call cm32_sdcc_fsread1
    jp _m32_tanhf
