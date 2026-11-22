
SECTION code_fp_math32

PUBLIC cm32_sdcc_exp

EXTERN cm32_sdcc_fsread1, _m32_expf

cm32_sdcc_exp:
    call cm32_sdcc_fsread1
    jp _m32_expf
