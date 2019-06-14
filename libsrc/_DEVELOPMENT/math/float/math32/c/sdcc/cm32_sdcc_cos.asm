
SECTION code_fp_math32

PUBLIC cm32_sdcc_cos

EXTERN cm32_sdcc_fsread1, _m32_cosf

cm32_sdcc_cos:
    call cm32_sdcc_fsread1
    jp _m32_cosf
