

SECTION code_fp_math16
PUBLIC cm16_sccz80_exp2

EXTERN cm16_sccz80_read1, exp2f16

cm16_sccz80_exp2:
    call cm16_sccz80_read1
    jp exp2f16
