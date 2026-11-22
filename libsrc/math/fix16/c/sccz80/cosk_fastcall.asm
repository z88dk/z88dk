    SECTION code_clib

    PUBLIC  cosk_fastcall
    PUBLIC  _cosk_fastcall

    EXTERN  asm_fix16_cos

    defc    cosk_fastcall = asm_fix16_cos
    defc    _cosk_fastcall = asm_fix16_cos