

    SECTION code_clib

    PUBLIC  atanfix88
    PUBLIC  _atanfix88
    PUBLIC  atanfix88_fastcall
    PUBLIC  _atanfix88_fastcall

    EXTERN  l_fix88_atan


atanfix88:
_atanfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
atanfix88_fastcall:
_atanfix88_fastcall:
    jp      l_fix88_atan

