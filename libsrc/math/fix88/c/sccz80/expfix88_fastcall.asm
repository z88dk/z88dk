    SECTION code_clib

    PUBLIC  expfix88_fastcall
    PUBLIC  _expfix88_fastcall

    EXTERN  asm_fix88_exp

    defc    expfix88_fastcall = asm_fix88_exp
    defc    _expfix88_fastcall = asm_fix88_exp