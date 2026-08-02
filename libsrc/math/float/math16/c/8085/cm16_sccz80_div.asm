SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_div
EXTERN asm_f16_div_callee
.cm16_sccz80_div
    pop bc
    pop hl
    push bc
    jp asm_f16_div_callee
