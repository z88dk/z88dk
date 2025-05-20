
    SECTION code_clib

    PUBLIC  res_MODE0
    EXTERN  CONSOLE_ROWS
    EXTERN  CONSOLE_COLUMNS

res_MODE0:
    ; Reduce coordinates down to h=x, l=y
    ld      a, h
    and     a
    ret     nz
    ld      h, l
    ld      a, d
    and     a
    ret     nz
    ld      l, e

    defc    NEEDunplot=1
    defc    WIDE_GFX=1
    INCLUDE "gfx/gencon/pixel.inc"
