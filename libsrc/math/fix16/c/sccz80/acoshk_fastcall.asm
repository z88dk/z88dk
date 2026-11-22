    SECTION code_clib

    PUBLIC  acoshk_fastcall
    PUBLIC  _acoshk_fastcall

    EXTERN  asm_fix16_acosh

    defc    acoshk_fastcall = asm_fix16_acosh
    defc    _acoshk_fastcall = asm_fix16_acosh