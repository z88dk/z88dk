    SECTION code_clib

    PUBLIC  invk_fastcall
    PUBLIC  _invk_fastcall

    EXTERN  asm_fix16_inv

    defc    invk_fastcall = asm_fix16_inv
    defc    _invk_fastcall = asm_fix16_inv