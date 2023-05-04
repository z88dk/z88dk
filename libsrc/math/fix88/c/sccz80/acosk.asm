

    SECTION code_clib

    PUBLIC  acosk
    PUBLIC  _acosk
    EXTERN  asm_fix16_acos


acosk:
_acosk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_acos

