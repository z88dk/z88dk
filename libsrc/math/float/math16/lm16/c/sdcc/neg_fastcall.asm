
    SECTION code_fp_math16
    PUBLIC  _negf16_fastcall
    EXTERN  asm_f16_neg

    defc    _negf16_fastcall = asm_f16_neg
