

SECTION code_fp_math16
PUBLIC cm16_sccz80_acos

EXTERN cm16_sccz80_read1, acosf16

cm16_sccz80_acos:
    call cm16_sccz80_read1
    jp acosf16
