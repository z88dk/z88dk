
    SECTION code_fp_math16

    PUBLIC  l_f16_div

    PUBLIC  divf16
    PUBLIC  divf16_callee

    EXTERN  asm_f16_div_callee

    EXTERN  cm16_sccz80_div
    EXTERN  cm16_sccz80_div_callee

    defc l_f16_div = asm_f16_div_callee

    defc divf16 = cm16_sccz80_div
    defc divf16_callee = cm16_sccz80_div_callee

