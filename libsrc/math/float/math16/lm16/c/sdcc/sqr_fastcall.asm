    SECTION code_clib
    SECTION code_fp_math16
    PUBLIC  _sqrf16_fastcall
    EXTERN  asm_f16_sqr

    defc    _sqrf16_fastcall = asm_f16_sqr
