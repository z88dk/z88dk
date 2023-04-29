

    SECTION code_clib

    PUBLIC  sqrfix88
    PUBLIC  _sqrfix88


    EXTERN  asm_fix88_sqr


sqrfix88:
_sqrfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_sqr

