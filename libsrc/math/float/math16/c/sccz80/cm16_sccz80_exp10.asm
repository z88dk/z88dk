

SECTION code_fp_math16
PUBLIC cm16_sccz80_exp10

EXTERN cm16_sccz80_read1, exp10f16

cm16_sccz80_exp10:
    call cm16_sccz80_read1
    jp exp10f16
