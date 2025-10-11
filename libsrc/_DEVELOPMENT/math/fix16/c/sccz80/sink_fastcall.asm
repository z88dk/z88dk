    SECTION code_clib

    PUBLIC  sink_fastcall
    PUBLIC  _sink_fastcall

    EXTERN  asm_fix16_sin

    defc    sink_fastcall = asm_fix16_sin
    defc    _sink_fastcall = asm_fix16_sin