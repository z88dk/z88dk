    SECTION code_clib

    PUBLIC  asinhfix88_fastcall
    PUBLIC  _asinhfix88_fastcall

    EXTERN  asm_fix88_asinh

    defc    asinhfix88_fastcall = asm_fix88_asinh
    defc    _asinhfix88_fastcall = asm_fix88_asinh