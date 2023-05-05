    SECTION code_clib

    PUBLIC  tanhk_fastcall
    PUBLIC  _tanhk_fastcall

    EXTERN  asm_fix16_tanh

    defc    tanhk_fastcall = asm_fix16_tanh
    defc    _tanhk_fastcall = asm_fix16_tanh