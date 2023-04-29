

    SECTION code_clib

    PUBLIC  pow2fix88
    PUBLIC  _pow2fix88
    PUBLIC  pow2fix88_fastcall
    PUBLIC  _pow2fix88_fastcall

    EXTERN  asm_fix88_pow2


pow2fix88:
_pow2fix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
pow2fix88_fastcall:
_pow2fix88_fastcall:
    jp      asm_fix88_pow2

