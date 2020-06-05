
SECTION code_fp_math16
PUBLIC cm16_sccz80_mul2

EXTERN cm16_sccz80_read1, asm_f16_mul2

cm16_sccz80_mul2:
    call cm16_sccz80_read1
    jp asm_f16_mul2

