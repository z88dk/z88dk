

    SECTION code_clib

    PUBLIC  invfix88
    PUBLIC  _invfix88
    EXTERN  asm_fix88_inv


invfix88:
_invfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_inv

