    SECTION code_clib

    PUBLIC  tanhfix88_fastcall
    PUBLIC  _tanhfix88_fastcall

    EXTERN  asm_fix88_tanh

    defc    tanhfix88_fastcall = asm_fix88_tanh
    defc    _tanhfix88_fastcall = asm_fix88_tanh