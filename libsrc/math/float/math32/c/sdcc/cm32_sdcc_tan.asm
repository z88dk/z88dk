
SECTION code_fp_math32

PUBLIC cm32_sdcc_tan

EXTERN cm32_sdcc_fsread1, _m32_tanf

cm32_sdcc_tan:
    call cm32_sdcc_fsread1
    jp _m32_tanf
