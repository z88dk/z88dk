; 04.2006 aralbrec
; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

    SECTION code_clib
    PUBLIC  zx_border
    PUBLIC  _zx_border
    PUBLIC  zx_border_fastcall
    PUBLIC  _zx_border_fastcall

    EXTERN  __SYSVAR_BORDCR

zx_border:
_zx_border:
    ld       hl,2
    add      hl,sp
    ld       l,(hl)

zx_border_fastcall:
_zx_border_fastcall:
    in      a, (254)
    and     $40

    rra
    rra
    or      l

    out     (254), a
    and     7
    rla
    rla
    rla
    ld      e, a
    ld      a, (__SYSVAR_BORDCR)
    and     $c7
    or      e
    ld      (__SYSVAR_BORDCR), a

    ret
