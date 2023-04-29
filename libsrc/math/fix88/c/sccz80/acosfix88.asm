

    SECTION code_clib

    PUBLIC  acosfix88
    PUBLIC  _acosfix88
    EXTERN  asm_fix88_acos


acosfix88:
_acosfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_acos

