
SECTION code_fp_math16

PUBLIC cm16_sdcc_log

EXTERN cm16_sdcc_read1, logf16

cm16_sdcc_log:
    call cm16_sdcc_read1
    jp logf16
