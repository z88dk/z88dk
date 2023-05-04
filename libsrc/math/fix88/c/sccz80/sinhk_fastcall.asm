    SECTION code_clib

    PUBLIC  sinhk_fastcall
    PUBLIC  _sinhk_fastcall

    EXTERN  asm_fix16_sinh

    defc    sinhk_fastcall = asm_fix16_sinh
    defc    _sinhk_fastcall = asm_fix16_sinh