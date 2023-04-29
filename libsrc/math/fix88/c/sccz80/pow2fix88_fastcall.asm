    SECTION code_clib

    PUBLIC  pow2fix88_fastcall
    PUBLIC  _pow2fix88_fastcall

    EXTERN  asm_fix88_pow2

    defc    pow2fix88_fastcall = asm_fix88_pow2
    defc    _pow2fix88_fastcall = asm_fix88_pow2