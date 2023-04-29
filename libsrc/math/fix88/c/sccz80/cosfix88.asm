

    SECTION code_clib

    PUBLIC  cosfix88
    PUBLIC  _cosfix88

    EXTERN  asm_fix88_cos


cosfix88:
_cosfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_cos

