

    SECTION code_clib

    PUBLIC  asinhk
    PUBLIC  _asinhk
    EXTERN  asm_fix16_asinh


asinhk:
_asinhk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_asinh

