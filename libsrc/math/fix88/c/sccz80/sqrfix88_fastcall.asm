    SECTION code_clib

    PUBLIC  sqrfix88_fastcall
    PUBLIC  _sqrfix88_fastcall

    EXTERN  asm_fix88_sqr

    defc    sqrfix88_fastcall = asm_fix88_sqr
    defc    _sqrfix88_fastcall = asm_fix88_sqr