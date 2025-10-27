
    SECTION code_fp_math16
    PUBLIC  _fabsf16_fastcall
    EXTERN  asm_f16_fabs

    defc    _fabsf16_fastcall = asm_f16_fabs
