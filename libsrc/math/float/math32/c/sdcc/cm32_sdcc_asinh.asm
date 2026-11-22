
SECTION code_fp_math32

PUBLIC cm32_sdcc_asinh

EXTERN cm32_sdcc_fsread1, _m32_asinhf

cm32_sdcc_asinh:
    call cm32_sdcc_fsread1
    jp _m32_asinhf
