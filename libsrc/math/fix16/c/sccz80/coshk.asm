

    SECTION code_clib

    PUBLIC  coshk
    PUBLIC  _coshk
    EXTERN  asm_fix16_cosh


coshk:
_coshk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_cosh

