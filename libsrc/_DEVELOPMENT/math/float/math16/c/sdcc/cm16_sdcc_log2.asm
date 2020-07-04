
SECTION code_fp_math16

PUBLIC cm16_sdcc_log2

EXTERN cm16_sdcc_read1, log2f16

cm16_sdcc_log2:
    call cm16_sdcc_read1
    jp log2f16
