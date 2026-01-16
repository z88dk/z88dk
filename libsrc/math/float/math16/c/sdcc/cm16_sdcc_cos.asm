
SECTION code_fp_math16

PUBLIC cm16_sdcc_cos

EXTERN cm16_sdcc_read1, cosf16

cm16_sdcc_cos:
    call cm16_sdcc_read1
    jp cosf16
