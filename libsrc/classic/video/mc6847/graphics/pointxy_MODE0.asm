
    SECTION code_clib

    PUBLIC  pointxy_MODE0
    INCLUDE "classic/video/mc6847/mc6847.inc"


pointxy_MODE0:
    ld      a, l
IF MODE0_3x2
    cp      48
ELIF MODE0_1x1
    cp      16
ELSE
    cp      32
ENDIF
    ret     nc
    ld      a, h
IF MODE0_1x1
    cp      MC6847_CONSOLE_COLUMNS
ELSE
    cp      MC6847_CONSOLE_COLUMNS * 2
ENDIF
    ret     nc

    defc    NEEDpoint=1
IF MODE0_3x2
    INCLUDE "classic/gfx/gencon/pixel6.inc"
ELIF MODE0_1x1
    INCLUDE "classic/gfx/gencon/pixel1.inc"
ELSE
    INCLUDE "classic/gfx/gencon/pixel.inc"
ENDIF