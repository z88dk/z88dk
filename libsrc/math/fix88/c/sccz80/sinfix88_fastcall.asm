    SECTION code_clib

    PUBLIC  sinfix88_fastcall
    PUBLIC  _sinfix88_fastcall

    EXTERN  asm_fix88_sin

    defc    sinfix88_fastcall = asm_fix88_sin
    defc    _sinfix88_fastcall = asm_fix88_sin