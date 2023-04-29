

    SECTION code_clib

    PUBLIC  sinfix88
    PUBLIC  _sinfix88


    EXTERN  asm_fix88_sin


sinfix88:
_sinfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_sin

