
SECTION code_fp_math16

PUBLIC cm16_sdcc_log10

EXTERN cm16_sdcc_read1, log10f16

cm16_sdcc_log10:
    call cm16_sdcc_read1
    jp log10f16
