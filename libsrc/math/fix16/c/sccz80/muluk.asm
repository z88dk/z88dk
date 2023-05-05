

    SECTION code_clib

    PUBLIC  muluk
    PUBLIC  _muluk

    EXTERN  asm_fix16_mulu


muluk:
_muluk:
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
    jp      asm_fix16_mulu

