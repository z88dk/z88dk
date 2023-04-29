    SECTION code_clib

    PUBLIC  tanfix88_fastcall
    PUBLIC  _tanfix88_fastcall

    EXTERN  asm_fix88_tan

    defc    tanfix88_fastcall = asm_fix88_tan
    defc    _tanfix88_fastcall = asm_fix88_tan