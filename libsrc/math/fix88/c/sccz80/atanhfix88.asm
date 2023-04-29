

    SECTION code_clib

    PUBLIC  atanhfix88
    PUBLIC  _atanhfix88
    EXTERN  asm_fix88_atanh


atanhfix88:
_atanhfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_atanh

