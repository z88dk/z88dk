   SECTION code_clib


    PUBLIC  fabsfix88_fastcall
    PUBLIC  _fabsfix88_fastcall

    EXTERN  asm_fix88_fabs

    defc    fabsfix88_fastcall = asm_fix88_fabs
    defc    _fabsfix88_fastcall = asm_fix88_fabs
