

    SECTION code_clib

    PUBLIC  expk
    PUBLIC  _expk
    EXTERN  asm_fix16_exp


expk:
_expk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_exp

