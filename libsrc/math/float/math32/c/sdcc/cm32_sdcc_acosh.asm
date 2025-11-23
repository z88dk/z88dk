
SECTION code_fp_math32

PUBLIC cm32_sdcc_acosh

EXTERN cm32_sdcc_fsread1, _m32_acoshf

cm32_sdcc_acosh:
    call cm32_sdcc_fsread1
    jp _m32_acoshf
