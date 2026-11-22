    SECTION code_clib
    SECTION code_fp_math16
    PUBLIC  sqrf16_fastcall
    EXTERN  asm_f16_sqr

    defc    sqrf16_fastcall = asm_f16_sqr
