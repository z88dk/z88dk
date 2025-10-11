   SECTION code_clib


    PUBLIC  absk_fastcall
    PUBLIC  _absk_fastcall

    EXTERN  asm_fix16_fabs

    defc    absk_fastcall = asm_fix16_fabs
    defc    _absk_fastcall = asm_fix16_fabs
