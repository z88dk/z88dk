
SECTION code_fp_math32

PUBLIC cm32_sdcc_round

EXTERN cm32_sdcc_fsread1, _m32_roundf

cm32_sdcc_round:
    call cm32_sdcc_fsread1
    jp _m32_roundf
