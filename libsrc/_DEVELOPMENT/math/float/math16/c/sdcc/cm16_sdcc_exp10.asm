
SECTION code_fp_math16

PUBLIC cm16_sdcc_exp10

EXTERN cm16_sdcc_read1, exp10f16

cm16_sdcc_exp10:
    call cm16_sdcc_read1
    jp exp10f16
