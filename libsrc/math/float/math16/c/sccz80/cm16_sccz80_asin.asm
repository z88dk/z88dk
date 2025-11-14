

SECTION code_fp_math16
PUBLIC cm16_sccz80_asin

EXTERN cm16_sccz80_read1, asinf16

cm16_sccz80_asin:
    call cm16_sccz80_read1
    jp asinf16
