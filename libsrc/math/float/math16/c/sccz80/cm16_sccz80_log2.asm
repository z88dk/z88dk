

SECTION code_fp_math16
PUBLIC cm16_sccz80_log2

EXTERN cm16_sccz80_read1, log2f16

cm16_sccz80_log2:
    call cm16_sccz80_read1
    jp log2f16
