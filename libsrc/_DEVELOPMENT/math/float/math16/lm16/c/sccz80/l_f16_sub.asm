
    SECTION code_fp_math16

    PUBLIC  l_f16_sub

    PUBLIC  m16_sub
    PUBLIC  m16_sub_callee

    EXTERN  asm_f16_sub_callee

    EXTERN  cm16_sccz80_sub
    EXTERN  cm16_sccz80_sub_callee

    defc l_f16_sub = asm_f16_sub_callee

    defc m16_sub = cm16_sccz80_sub
    defc m16_sub_callee = cm16_sccz80_sub_callee

