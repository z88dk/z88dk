

SECTION code_clib

PUBLIC clg
PUBLIC _clg

EXTERN __agon_putc


clg:
_clg:
    ld      a,16
    jp      __agon_putc
