    SECTION code_clib

    PUBLIC  atanhfix88_fastcall
    PUBLIC  _atanhfix88_fastcall

    EXTERN  asm_fix88_atanh

    defc    atanhfix88_fastcall = asm_fix88_atanh
    defc    _atanhfix88_fastcall = asm_fix88_atanh