    SECTION code_clib

    PUBLIC  sqrtk_fastcall
    PUBLIC  _sqrtk_fastcall

    EXTERN  asm_fix16_sqrt

    defc    sqrtk_fastcall = asm_fix16_sqrt
    defc    _sqrtk_fastcall = asm_fix16_sqrt