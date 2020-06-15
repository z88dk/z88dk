
    SECTION code_fp_math16
    PUBLIC  _sqrtf16_fastcall
    EXTERN  asm_f16_sqrt

    defc    _sqrtf16_fastcall = asm_f16_sqrt
