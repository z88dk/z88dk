
; half __div_callee (half left, half right) — restoring div

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_div_callee

EXTERN asm_f16_div_callee

defc cm16_sccz80_div_callee = asm_f16_div_callee
                            ; enter : HL = right, stack = left, ret
                            ; exit  : HL = left/right
