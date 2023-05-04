

    SECTION code_clib

    PUBLIC  acoshk
    PUBLIC  _acoshk
    EXTERN  asm_fix16_acosh


acoshk:
_acoshk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_acosh

