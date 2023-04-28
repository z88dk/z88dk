

    SECTION code_clib

    PUBLIC  tanfix88
    PUBLIC  _tanfix88
    PUBLIC  tanfix88_fastcall
    PUBLIC  _tanfix88_fastcall

    EXTERN  l_fix88_tan


tanfix88:
_tanfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
tanfix88_fastcall:
_tanfix88_fastcall:
    jp      l_fix88_tan

