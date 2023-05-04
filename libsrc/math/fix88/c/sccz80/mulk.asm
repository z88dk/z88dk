

    SECTION code_clib

    PUBLIC  mulk
    PUBLIC  _mulk

    EXTERN  asm_fix16_muls


mulk:
_mulk:
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
    jp      asm_fix16_muls

