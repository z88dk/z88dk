
    SECTION code_clib

    PUBLIC  plot_MODE0
    EXTERN  CONSOLE_ROWS
    EXTERN  CONSOLE_COLUMNS

.plot_MODE0
    ; Reduce coordinates down to h=x, l=y
    ld      a,h
    and     a
    ret     nz
    ld      h,l
    ld      a,d
    and     a
    ret     nz
    ld      l,e

    ld      a,l
    cp      CONSOLE_ROWS * 2
    ret     nc
    ld      a,h
    cp      CONSOLE_COLUMNS * 2
    ret     nc

    defc    NEEDplot = 1
    INCLUDE "gfx/gencon/pixel.inc"
