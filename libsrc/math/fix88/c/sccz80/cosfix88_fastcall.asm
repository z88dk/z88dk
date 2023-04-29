    SECTION code_clib

    PUBLIC  cosfix88_fastcall
    PUBLIC  _cosfix88_fastcall

    EXTERN  asm_fix88_cos

    defc    cosfix88_fastcall = asm_fix88_cos
    defc    _cosfix88_fastcall = asm_fix88_cos