

    SECTION code_clib

    PUBLIC  mulfix88
    PUBLIC  _mulfix88

    EXTERN  l_fix88_mult


mulfix88:
_mulfix88:
    ld      hl,2
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
    jp      l_fix88_mult

