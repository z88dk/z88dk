    SECTION code_clib

    PUBLIC  asink_fastcall
    PUBLIC  _asink_fastcall

    EXTERN  asm_fix16_asin

    defc    asink_fastcall = asm_fix16_asin
    defc    _asink_fastcall = asm_fix16_asin