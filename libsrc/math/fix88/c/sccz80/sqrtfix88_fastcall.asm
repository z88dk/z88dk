    SECTION code_clib

    PUBLIC  sqrtfix88_fastcall
    PUBLIC  _sqrtfix88_fastcall

    EXTERN  asm_fix88_sqrt

    defc    sqrtfix88_fastcall = asm_fix88_sqrt
    defc    _sqrtfix88_fastcall = asm_fix88_sqrt