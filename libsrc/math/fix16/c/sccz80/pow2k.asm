

    SECTION code_clib

    PUBLIC  pow2k
    PUBLIC  _pow2k
    PUBLIC  pow2k_fastcall
    PUBLIC  _pow2k_fastcall

    EXTERN  asm_fix16_pow2


pow2k:
_pow2k:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
pow2k_fastcall:
_pow2k_fastcall:
    jp      asm_fix16_pow2

