
    SECTION code_fp_math16

    PUBLIC  l_f16_add
    PUBLIC  m16_add_callee

    EXTERN  cm16_sccz80_add_callee

    defc l_f16_add = cm16_sccz80_add_callee
    defc m16_add_callee = cm16_sccz80_add_callee

    PUBLIC  m16_add

    EXTERN  cm16_sccz80_add

    defc m16_add = cm16_sccz80_add

