

    SECTION code_clib

    PUBLIC  lnk
    PUBLIC  _lnk
    PUBLIC  lnk_fastcall
    PUBLIC  _lnk_fastcall

    EXTERN  asm_fix16_ln


lnk:
_lnk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
lnk_fastcall:
_lnk_fastcall:
    jp      asm_fix16_ln

