
SECTION code_fp_math16

PUBLIC cm16_sdcc_acos

EXTERN cm16_sdcc_read1, acosf16

cm16_sdcc_acos:
    call cm16_sdcc_read1
    jp acosf16
