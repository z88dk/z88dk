
    SECTION code_fp_math16

    PUBLIC  l_f16_mul

    PUBLIC  mulf16
    PUBLIC  mulf16_callee

    EXTERN  asm_f16_mul_callee

    EXTERN  cm16_sccz80_mul
    EXTERN  cm16_sccz80_mul_callee

    defc l_f16_mul = asm_f16_mul_callee

    defc mulf16 = cm16_sccz80_mul
    defc mulf16_callee = cm16_sccz80_mul_callee

