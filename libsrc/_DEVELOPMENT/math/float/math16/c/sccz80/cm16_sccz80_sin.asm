

SECTION code_fp_math16
PUBLIC cm16_sccz80_sin

EXTERN cm16_sccz80_read1, sinf16

cm16_sccz80_sin:
    call cm16_sccz80_read1
    jp sinf16
