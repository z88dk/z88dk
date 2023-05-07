    SECTION code_clib

    PUBLIC  sqrk_fastcall
    PUBLIC  _sqrk_fastcall

    EXTERN  asm_fix16_sqr

    defc    sqrk_fastcall = asm_fix16_sqr
    defc    _sqrk_fastcall = asm_fix16_sqr