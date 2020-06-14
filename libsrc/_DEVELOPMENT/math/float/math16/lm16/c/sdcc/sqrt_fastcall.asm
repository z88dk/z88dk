
    SECTION code_fp_math16
    PUBLIC  _f16_sqrt_fastcall
    EXTERN  asm_f16_sqrt

    defc    _f16_sqrt_fastcall = asm_f16_sqrt
