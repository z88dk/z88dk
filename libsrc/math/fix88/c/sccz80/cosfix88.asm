

    SECTION code_clib

    PUBLIC  cosfix88
    PUBLIC  _cosfix88
    PUBLIC  cosfix88_fastcall
    PUBLIC  _cosfix88_fastcall

    EXTERN  l_fix88_cos


cosfix88:
_cosfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
cosfix88_fastcall:
_cosfix88_fastcall:
    jp      l_fix88_cos

