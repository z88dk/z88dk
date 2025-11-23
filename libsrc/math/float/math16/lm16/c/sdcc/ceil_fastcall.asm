
    SECTION code_fp_math16
    PUBLIC  _ceilf16_fastcall
    EXTERN  asm_f16_ceil

    defc    _ceilf16_fastcall = asm_f16_ceil
