

    SECTION code_clib

    PUBLIC  tanfix88
    PUBLIC  _tanfix88

    EXTERN  asm_fix88_tan


tanfix88:
_tanfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_tan

