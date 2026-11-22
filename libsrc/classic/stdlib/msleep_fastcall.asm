


    SECTION code_clib

    PUBLIC  msleep_fastcall
    PUBLIC  _msleep_fastcall

    EXTERN  asm_cpu_delay_ms

    defc    msleep_fastcall=asm_cpu_delay_ms
    defc    _msleep_fastcall=asm_cpu_delay_ms
