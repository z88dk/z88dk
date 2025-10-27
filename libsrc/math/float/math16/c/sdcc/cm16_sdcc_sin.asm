
SECTION code_fp_math16

PUBLIC cm16_sdcc_sin

EXTERN cm16_sdcc_read1, sinf16

cm16_sdcc_sin:
    call cm16_sdcc_read1
    jp sinf16
