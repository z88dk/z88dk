

    SECTION code_clib

    PUBLIC  absfix88
    PUBLIC  _absfix88

    EXTERN  asm_fix88_mult


absfix88:
_absfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
absfix88_fastcall:
_absfix88_fastcall:
    res     7,h
    ret
