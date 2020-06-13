
    SECTION code_fp_math16

    PUBLIC  l_f16_add

    PUBLIC  f16_add
    PUBLIC  f16_add_callee

    EXTERN  asm_f16_add_callee

    EXTERN  cm16_sccz80_add
    EXTERN  cm16_sccz80_add_callee

    defc l_f16_add = asm_f16_add_callee

    defc f16_add = cm16_sccz80_add
    defc f16_add_callee = cm16_sccz80_add_callee

