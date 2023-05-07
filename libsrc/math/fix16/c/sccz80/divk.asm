

    SECTION code_clib

    PUBLIC  divk
    PUBLIC  _divk

    EXTERN  asm_fix16_divs


divk:
_divk:
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
    jp      asm_fix16_divs

