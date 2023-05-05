

    SECTION code_clib

    PUBLIC  sqrtk
    PUBLIC  _sqrtk


    EXTERN  asm_fix16_sqrt


sqrtk:
_sqrtk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_sqrt

