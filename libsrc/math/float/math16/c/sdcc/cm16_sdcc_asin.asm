
SECTION code_fp_math16

PUBLIC cm16_sdcc_asin

EXTERN cm16_sdcc_read1, asinf16

cm16_sdcc_asin:
    call cm16_sdcc_read1
    jp asinf16
