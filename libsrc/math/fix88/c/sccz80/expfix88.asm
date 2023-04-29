

    SECTION code_clib

    PUBLIC  expfix88
    PUBLIC  _expfix88
    EXTERN  asm_fix88_exp


expfix88:
_expfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_exp

