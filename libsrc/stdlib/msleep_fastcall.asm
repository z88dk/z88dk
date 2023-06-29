


    SECTION code_clib

    PUBLIC  msleep_fastcall
    PUBLIC  _msleep_fastcall

    EXTERN  asm_z80_delay_ms

    defc    msleep_fastcall = asm_z80_delay_ms
    defc    _msleep_fastcall = asm_z80_delay_ms
