

    SECTION code_clib

    PUBLIC  invk
    PUBLIC  _invk
    EXTERN  asm_fix16_inv


invk:
_invk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_inv

