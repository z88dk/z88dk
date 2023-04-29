    SECTION code_clib

    PUBLIC  coshfix88_fastcall
    PUBLIC  _coshfix88_fastcall

    EXTERN  asm_fix88_cosh

    defc    coshfix88_fastcall = asm_fix88_cosh
    defc    _coshfix88_fastcall = asm_fix88_cosh