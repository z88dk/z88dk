

SECTION code_fp_math16
PUBLIC cm16_sccz80_exp

EXTERN cm16_sccz80_read1, expf16

cm16_sccz80_exp:
    call cm16_sccz80_read1
    jp expf16
