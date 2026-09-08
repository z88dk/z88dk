; half __mul_callee (half left, half right)
; Packed 11×11. HL = right, stack = left, ret.

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_mul_callee

EXTERN asm_f16_mul_callee

defc cm16_sccz80_mul_callee = asm_f16_mul_callee

