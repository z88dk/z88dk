    SECTION code_clib

    PUBLIC  acosfix88_fastcall
    PUBLIC  _acosfix88_fastcall

    EXTERN  asm_fix88_acos

    defc    acosfix88_fastcall = asm_fix88_acos
    defc    _acosfix88_fastcall = asm_fix88_acos