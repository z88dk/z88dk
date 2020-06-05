
SECTION code_fp_math16
PUBLIC cm16_sccz80_mul10

EXTERN cm16_sccz80_read1, asm_f16_mul10

.cm16_sccz80_mul10
    call cm16_sccz80_read1
    jp asm_f16_mul10

