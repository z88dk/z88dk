    SECTION code_clib


    PUBLIC  atank_fastcall
    PUBLIC  _atank_fastcall

    EXTERN  asm_fix16_atan

    defc    atank_fastcall = asm_fix16_atan
    defc    _atank_fastcall = asm_fix16_atan
