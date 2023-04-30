

    SECTION code_clib

    PUBLIC  fabsfix88
    PUBLIC  _fabsfix88

    EXTERN  asm_fabs

fabsfix88:
_fabsfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
    jp      asm_fabs
