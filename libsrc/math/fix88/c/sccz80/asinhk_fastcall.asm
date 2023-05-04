    SECTION code_clib

    PUBLIC  asinhk_fastcall
    PUBLIC  _asinhk_fastcall

    EXTERN  asm_fix16_asinh

    defc    asinhk_fastcall = asm_fix16_asinh
    defc    _asinhk_fastcall = asm_fix16_asinh