
    SECTION code_fp_math16

    PUBLIC  l_f16_mul

    PUBLIC  f16_mul
    PUBLIC  f16_mul_callee

    EXTERN  asm_f16_mul_callee

    EXTERN  cm16_sccz80_mul
    EXTERN  cm16_sccz80_mul_callee

    defc l_f16_mul = asm_f16_mul_callee

    defc f16_mul = cm16_sccz80_mul
    defc f16_mul_callee = cm16_sccz80_mul_callee

