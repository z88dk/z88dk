

    SECTION code_clib

    PUBLIC  powk
    PUBLIC  _powk

    EXTERN  asm_fix16_pow


powk:
_powk:
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
    jp      asm_fix16_pow

