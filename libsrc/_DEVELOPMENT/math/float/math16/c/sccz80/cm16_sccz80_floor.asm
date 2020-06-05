
SECTION code_fp_math16
PUBLIC cm16_sccz80_floor

EXTERN cm16_sccz80_read1, asm_f16_floor

cm16_sccz80_floor:
    call cm16_sccz80_read1
    jp asm_f16_floor

