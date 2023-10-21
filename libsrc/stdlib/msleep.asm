


    SECTION code_clib

    PUBLIC  msleep
    PUBLIC  _msleep

    EXTERN  asm_z80_delay_ms

    ; int msleep(unsigned int millis)

msleep:
_msleep:
    pop     de
    pop     hl
    push    hl
    push    de
    jp      asm_z80_delay_ms
