

    SECTION code_clib

    PUBLIC  sqrtfix88
    PUBLIC  _sqrtfix88


    EXTERN  asm_fix88_sqrt


sqrtfix88:
_sqrtfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_sqrt

