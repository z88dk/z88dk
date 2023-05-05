

    SECTION code_clib

    PUBLIC  atank
    PUBLIC  _atank

    EXTERN  asm_fix16_atan


atank:
_atank:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_atan

