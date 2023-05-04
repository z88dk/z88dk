

    SECTION code_clib

    PUBLIC  fabsk
    PUBLIC  _fabsk

    EXTERN  asm_fix16_fabs

fabsk:
_fabsk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
    jp      asm_fix16_fabs
