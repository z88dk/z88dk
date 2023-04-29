    SECTION code_clib

    PUBLIC  sinhfix88_fastcall
    PUBLIC  _sinhfix88_fastcall

    EXTERN  asm_fix88_sinh

    defc    sinhfix88_fastcall = asm_fix88_sinh
    defc    _sinhfix88_fastcall = asm_fix88_sinh