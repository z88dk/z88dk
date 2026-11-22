SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_mul
EXTERN asm_f16_mul_callee
.cm16_sccz80_mul
    pop bc
    pop hl
    push bc
    jp asm_f16_mul_callee
