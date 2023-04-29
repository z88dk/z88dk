    SECTION code_clib

    PUBLIC  acoshfix88_fastcall
    PUBLIC  _acoshfix88_fastcall

    EXTERN  asm_fix88_acosh

    defc    acoshfix88_fastcall = asm_fix88_acosh
    defc    _acoshfix88_fastcall = asm_fix88_acosh