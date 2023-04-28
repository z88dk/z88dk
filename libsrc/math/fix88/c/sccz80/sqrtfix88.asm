

    SECTION code_clib

    PUBLIC  sqrtfix88
    PUBLIC  _sqrtfix88
    PUBLIC  sqrtfix88_fastcall
    PUBLIC  _sqrtfix88_fastcall

    EXTERN  l_fix88_sqrt


sqrtfix88:
_sqrtfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
sqrtfix88_fastcall:
_sqrtfix88_fastcall:
    jp      l_fix88_sqrt

