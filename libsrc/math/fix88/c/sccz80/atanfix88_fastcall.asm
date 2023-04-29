    SECTION code_clib


    PUBLIC  atanfix88_fastcall
    PUBLIC  _atanfix88_fastcall

    EXTERN  asm_fix88_atan

    defc    atanfix88_fastcall = asm_fix88_atan
    defc    _atanfix88_fastcall = asm_fix88_atan
