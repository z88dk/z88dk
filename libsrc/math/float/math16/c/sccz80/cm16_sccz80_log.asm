

SECTION code_fp_math16
PUBLIC cm16_sccz80_log

EXTERN cm16_sccz80_read1, logf16

cm16_sccz80_log:
    call cm16_sccz80_read1
    jp logf16
