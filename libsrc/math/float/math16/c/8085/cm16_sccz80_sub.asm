SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_sub
EXTERN asm_f16_sub_callee
.cm16_sccz80_sub
    pop bc
    pop hl
    push bc
    jp asm_f16_sub_callee
