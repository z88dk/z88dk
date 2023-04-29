

    SECTION code_clib

    PUBLIC  coshfix88
    PUBLIC  _coshfix88
    EXTERN  asm_fix88_cosh


coshfix88:
_coshfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_cosh

