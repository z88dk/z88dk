
    SECTION code_clib

    PUBLIC  xor_MODE0
    EXTERN  CONSOLE_ROWS
    EXTERN  CONSOLE_COLUMNS

.xor_MODE0
    ld      a,l
    cp      CONSOLE_ROWS * 2
    ret     nc
    ld      a,h
    cp      CONSOLE_COLUMNS * 2
    ret     nc

    defc    NEEDxor = 1
    INCLUDE "gfx/gencon/pixel.inc"
