

    SECTION code_clib

    PUBLIC  invfix88
    PUBLIC  _invfix88
    PUBLIC  invfix88_fastcall
    PUBLIC  _invfix88_fastcall

    EXTERN  asm_fix88_inv


invfix88:
_invfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
invfix88_fastcall:
_invfix88_fastcall:
    jp      asm_fix88_inv

