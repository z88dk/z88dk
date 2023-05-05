    SECTION code_clib

    PUBLIC  tank_fastcall
    PUBLIC  _tank_fastcall

    EXTERN  asm_fix16_tan

    defc    tank_fastcall = asm_fix16_tan
    defc    _tank_fastcall = asm_fix16_tan