

    SECTION code_clib

    PUBLIC  asinfix88
    PUBLIC  _asinfix88
    EXTERN  asm_fix88_asin


asinfix88:
_asinfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_asin

