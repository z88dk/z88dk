    SECTION code_clib

    PUBLIC  acosk_fastcall
    PUBLIC  _acosk_fastcall

    EXTERN  asm_fix16_acos

    defc    acosk_fastcall = asm_fix16_acos
    defc    _acosk_fastcall = asm_fix16_acos