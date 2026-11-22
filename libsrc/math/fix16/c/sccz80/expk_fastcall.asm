    SECTION code_clib

    PUBLIC  expk_fastcall
    PUBLIC  _expk_fastcall

    EXTERN  asm_fix16_exp

    defc    expk_fastcall = asm_fix16_exp
    defc    _expk_fastcall = asm_fix16_exp