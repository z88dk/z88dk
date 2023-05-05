

    SECTION code_clib

    PUBLIC  sink
    PUBLIC  _sink


    EXTERN  asm_fix16_sin


sink:
_sink:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_sin

