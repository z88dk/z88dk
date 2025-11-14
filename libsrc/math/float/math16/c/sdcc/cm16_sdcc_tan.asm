
SECTION code_fp_math16

PUBLIC cm16_sdcc_tan

EXTERN cm16_sdcc_read1, tanf16

cm16_sdcc_tan:
    call cm16_sdcc_read1
    jp tanf16
