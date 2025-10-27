

SECTION code_fp_math16
PUBLIC cm16_sccz80_cos

EXTERN cm16_sccz80_read1, cosf16

cm16_sccz80_cos:
    call cm16_sccz80_read1
    jp cosf16
