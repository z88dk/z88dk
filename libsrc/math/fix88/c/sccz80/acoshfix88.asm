

    SECTION code_clib

    PUBLIC  acoshfix88
    PUBLIC  _acoshfix88
    EXTERN  asm_fix88_acosh


acoshfix88:
_acoshfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_acosh

