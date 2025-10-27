    SECTION code_clib

    PUBLIC  pow2k_fastcall
    PUBLIC  _pow2k_fastcall

    EXTERN  asm_fix16_pow2

    defc    pow2k_fastcall = asm_fix16_pow2
    defc    _pow2k_fastcall = asm_fix16_pow2