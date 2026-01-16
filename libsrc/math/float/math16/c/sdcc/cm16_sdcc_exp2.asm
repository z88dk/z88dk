
SECTION code_fp_math16

PUBLIC cm16_sdcc_exp2

EXTERN cm16_sdcc_read1, exp2f16

cm16_sdcc_exp2:
    call cm16_sdcc_read1
    jp exp2f16
