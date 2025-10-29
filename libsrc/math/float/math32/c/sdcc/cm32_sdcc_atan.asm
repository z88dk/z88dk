
SECTION code_fp_math32

PUBLIC cm32_sdcc_atan

EXTERN cm32_sdcc_fsread1, _m32_atanf

cm32_sdcc_atan:
    call cm32_sdcc_fsread1
    jp _m32_atanf
