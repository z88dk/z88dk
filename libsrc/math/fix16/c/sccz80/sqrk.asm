

    SECTION code_clib

    PUBLIC  sqrk
    PUBLIC  _sqrk


    EXTERN  asm_fix16_sqr


sqrk:
_sqrk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_sqr

