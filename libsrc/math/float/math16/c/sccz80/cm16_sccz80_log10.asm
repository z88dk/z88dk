

SECTION code_fp_math16
PUBLIC cm16_sccz80_log10

EXTERN cm16_sccz80_read1, log10f16

cm16_sccz80_log10:
    call cm16_sccz80_read1
    jp log10f16
