

    SECTION code_clib

    PUBLIC  absk
    PUBLIC  _absk

    EXTERN  asm_fix16_fabs

absk:
_absk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
    jp      asm_fix16_fabs
