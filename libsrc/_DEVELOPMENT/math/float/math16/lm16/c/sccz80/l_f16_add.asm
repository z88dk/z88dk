
    SECTION code_fp_math16

    PUBLIC  l_f16_add

    PUBLIC  addf16
    PUBLIC  addf16_callee

    EXTERN  asm_f16_add_callee

    EXTERN  cm16_sccz80_add
    EXTERN  cm16_sccz80_add_callee

    defc l_f16_add = asm_f16_add_callee

    defc addf16 = cm16_sccz80_add
    defc addf16_callee = cm16_sccz80_add_callee

