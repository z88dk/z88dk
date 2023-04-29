

    SECTION code_clib

    PUBLIC  sinfix88
    PUBLIC  _sinfix88
    PUBLIC  sinfix88_fastcall
    PUBLIC  _sinfix88_fastcall

    EXTERN  asm_fix88_sin


sinfix88:
_sinfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
sinfix88_fastcall:
_sinfix88_fastcall:
    jp      asm_fix88_sin

