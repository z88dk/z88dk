

    SECTION code_clib

    PUBLIC  sinhfix88
    PUBLIC  _sinhfix88
    EXTERN  asm_fix88_sinh


sinhfix88:
_sinhfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_sinh

