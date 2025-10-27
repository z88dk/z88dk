

SECTION code_fp_math16
PUBLIC cm16_sccz80_tan

EXTERN cm16_sccz80_read1, tanf16

cm16_sccz80_tan:
    call cm16_sccz80_read1
    jp tanf16
