    SECTION code_clib

    PUBLIC  invfix88_fastcall
    PUBLIC  _invfix88_fastcall

    EXTERN  asm_fix88_inv

    defc    invfix88_fastcall = asm_fix88_inv
    defc    _invfix88_fastcall = asm_fix88_inv