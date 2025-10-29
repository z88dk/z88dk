
    SECTION code_fp_math16

    PUBLIC  l_f16_sub

    PUBLIC  subf16
    PUBLIC  subf16_callee

    EXTERN  asm_f16_sub_callee

    EXTERN  cm16_sccz80_sub
    EXTERN  cm16_sccz80_sub_callee

    defc l_f16_sub = asm_f16_sub_callee

    defc subf16 = cm16_sccz80_sub
    defc subf16_callee = cm16_sccz80_sub_callee

