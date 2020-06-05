

SECTION code_fp_math16
PUBLIC cm16_sccz80_abs

EXTERN cm16_sccz80_read1, asm_f16_abs

.cm16_sccz80_abs
    call cm16_sccz80_read1
    jp asm_f16_abs

