

SECTION code_fp_math16
PUBLIC cm16_sccz80_sqrt

EXTERN cm16_sccz80_read1, asm_f16_sqrt

cm16_sccz80_sqrt:
    call cm16_sccz80_read1
    jp asm_f16_sqrt
