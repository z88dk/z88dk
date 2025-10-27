
SECTION code_fp_math32

PUBLIC cm32_sdcc_asin

EXTERN cm32_sdcc_fsread1, _m32_asinf

cm32_sdcc_asin:
    call cm32_sdcc_fsread1
    jp _m32_asinf
