

SECTION code_fp_math16
PUBLIC cm16_sccz80_atan

EXTERN cm16_sccz80_read1, atanf16

cm16_sccz80_atan:
    call cm16_sccz80_read1
    jp atanf16
