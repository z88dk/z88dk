

    SECTION code_clib

    PUBLIC  atanfix88
    PUBLIC  _atanfix88

    EXTERN  asm_fix88_atan


atanfix88:
_atanfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_atan

