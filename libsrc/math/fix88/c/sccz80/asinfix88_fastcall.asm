    SECTION code_clib

    PUBLIC  asinfix88_fastcall
    PUBLIC  _asinfix88_fastcall

    EXTERN  asm_fix88_asin

    defc    asinfix88_fastcall = asm_fix88_asin
    defc    _asinfix88_fastcall = asm_fix88_asin