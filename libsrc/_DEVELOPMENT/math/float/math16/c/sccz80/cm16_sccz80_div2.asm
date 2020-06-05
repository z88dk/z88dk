
SECTION code_fp_math16
PUBLIC cm16_sccz80_div2

EXTERN cm16_sccz80_read1, asm_f16_div2

cm16_sccz80_div2:
    call cm16_sccz80_read1
    jp asm_f16_div2

