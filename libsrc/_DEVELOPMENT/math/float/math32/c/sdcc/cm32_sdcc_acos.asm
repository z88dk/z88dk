
SECTION code_fp_math32

PUBLIC cm32_sdcc_acos

EXTERN cm32_sdcc_fsread1, _m32_acosf

cm32_sdcc_acos:
    call cm32_sdcc_fsread1
    jp _m32_acosf
