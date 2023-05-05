

    SECTION code_clib

    PUBLIC  sinhk
    PUBLIC  _sinhk
    EXTERN  asm_fix16_sinh


sinhk:
_sinhk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_sinh

