

    SECTION code_clib

    PUBLIC  powfix88
    PUBLIC  _powfix88

    EXTERN  asm_fix88_pow


powfix88:
_powfix88:
    ld      hl,2
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
    jp      asm_fix88_pow

