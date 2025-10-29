
SECTION code_fp_math16

PUBLIC cm16_sdcc_atan

EXTERN cm16_sdcc_read1, atanf16

cm16_sdcc_atan:
    call cm16_sdcc_read1
    jp atanf16
