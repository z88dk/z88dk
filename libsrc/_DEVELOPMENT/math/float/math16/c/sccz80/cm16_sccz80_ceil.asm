
SECTION code_fp_math16
PUBLIC cm16_sccz80_ceil

EXTERN cm16_sccz80_read1, asm_f16_ceil

cm16_sccz80_ceil:
    call cm16_sccz80_read1
    jp asm_f16_ceil

