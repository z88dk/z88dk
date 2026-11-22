
SECTION code_fp_math32

PUBLIC cm32_sdcc_log2

EXTERN cm32_sdcc_fsread1, _m32_log2f

cm32_sdcc_log2:
    call cm32_sdcc_fsread1
    jp _m32_log2f
