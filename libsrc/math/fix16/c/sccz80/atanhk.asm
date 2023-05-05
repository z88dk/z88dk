

    SECTION code_clib

    PUBLIC  atanhk
    PUBLIC  _atanhk
    EXTERN  asm_fix16_atanh


atanhk:
_atanhk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_atanh

