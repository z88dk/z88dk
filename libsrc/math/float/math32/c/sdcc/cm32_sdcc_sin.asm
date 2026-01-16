
SECTION code_fp_math32

PUBLIC cm32_sdcc_sin

EXTERN cm32_sdcc_fsread1, _m32_sinf

cm32_sdcc_sin:
    call cm32_sdcc_fsread1
    jp _m32_sinf
