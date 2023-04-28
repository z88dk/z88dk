

    SECTION code_clib

    PUBLIC  lnfix88
    PUBLIC  _lnfix88
    PUBLIC  lnfix88_fastcall
    PUBLIC  _lnfix88_fastcall

    EXTERN  l_fix88_ln


lnfix88:
_lnfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
lnfix88_fastcall:
_lnfix88_fastcall:
    jp      l_fix88_ln

