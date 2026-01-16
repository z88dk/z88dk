
SECTION code_fp_math16

PUBLIC cm16_sdcc_exp

EXTERN cm16_sdcc_read1, expf16

cm16_sdcc_exp:
    call cm16_sdcc_read1
    jp expf16
