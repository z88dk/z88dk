

    SECTION code_clib

    PUBLIC  asinhfix88
    PUBLIC  _asinhfix88
    EXTERN  asm_fix88_asinh


asinhfix88:
_asinhfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_asinh

