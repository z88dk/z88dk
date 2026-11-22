
SECTION code_fp_math32

PUBLIC cm32_sdcc_atanh

EXTERN cm32_sdcc_fsread1, _m32_atanhf

cm32_sdcc_atanh:
    call cm32_sdcc_fsread1
    jp _m32_atanhf
