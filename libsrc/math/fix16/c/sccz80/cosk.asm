

    SECTION code_clib

    PUBLIC  cosk
    PUBLIC  _cosk

    EXTERN  asm_fix16_cos


cosk:
_cosk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_cos

