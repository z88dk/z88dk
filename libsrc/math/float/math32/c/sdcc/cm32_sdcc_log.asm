
SECTION code_fp_math32

PUBLIC cm32_sdcc_log

EXTERN cm32_sdcc_fsread1, _m32_logf

cm32_sdcc_log:
    call cm32_sdcc_fsread1
    jp _m32_logf
