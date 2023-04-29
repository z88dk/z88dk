

    SECTION code_clib

    PUBLIC  absfix88
    PUBLIC  _absfix88

    PUBLIC  absfix88_fastcall
    PUBLIC  _absfix88_fastcall

    EXTERN  asm_abs

    defc    absfix88_fastcall = asm_abs
    defc    _absfix88_fastcall = asm_abs

absfix88:
_absfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
    jp      asm_abs
