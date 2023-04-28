

    SECTION code_clib

    PUBLIC  divfix88
    PUBLIC  _divfix88

    EXTERN  l_fix88_div


divfix88:
_divfix88:
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
    jp      l_fix88_div

