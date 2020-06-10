
    SECTION code_fp_math16

    PUBLIC  l_f16_div

    PUBLIC  f16_div
    PUBLIC  f16_div_callee

    EXTERN  asm_f16_div_callee

    EXTERN  cm16_sccz80_div
    EXTERN  cm16_sccz80_div_callee

    defc l_f16_div = asm_f16_div_callee

    defc f16_div = cm16_sccz80_div
    defc f16_div_callee = cm16_sccz80_div_callee

