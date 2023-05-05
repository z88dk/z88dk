    SECTION code_clib

    PUBLIC  atanhk_fastcall
    PUBLIC  _atanhk_fastcall

    EXTERN  asm_fix16_atanh

    defc    atanhk_fastcall = asm_fix16_atanh
    defc    _atanhk_fastcall = asm_fix16_atanh