
    SECTION code_fp_math16

    PUBLIC  l_f16_sub

    PUBLIC  f16_sub
    PUBLIC  f16_sub_callee

    EXTERN  asm_f16_sub_callee

    EXTERN  cm16_sccz80_sub
    EXTERN  cm16_sccz80_sub_callee

    defc l_f16_sub = asm_f16_sub_callee

    defc f16_sub = cm16_sccz80_sub
    defc f16_sub_callee = cm16_sccz80_sub_callee

