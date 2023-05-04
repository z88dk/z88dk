   SECTION code_clib


    PUBLIC  fabsk_fastcall
    PUBLIC  _fabsk_fastcall

    EXTERN  asm_fix16_fabs

    defc    fabsk_fastcall = asm_fix16_fabs
    defc    _fabsk_fastcall = asm_fix16_fabs
