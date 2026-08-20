SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_poly_callee
EXTERN asm_f16_poly_callee

; stack: x, d[], n, ret  — match asm_f16_poly_callee entry
defc cm16_sccz80_poly_callee = asm_f16_poly_callee
