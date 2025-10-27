    SECTION code_clib

    PUBLIC  coshk_fastcall
    PUBLIC  _coshk_fastcall

    EXTERN  asm_fix16_cosh

    defc    coshk_fastcall = asm_fix16_cosh
    defc    _coshk_fastcall = asm_fix16_cosh