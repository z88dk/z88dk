
    SECTION code_clib

    PUBLIC  pointxy_MODE0

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
    cp      64
    ret     nc

    defc    NEEDpoint=1
IF MODE0_3x2
    INCLUDE "gfx/gencon/pixel6.inc"
ELIF MODE0_1x1
    INCLUDE "gfx/gencon/pixel1.inc"
ELSE
    INCLUDE "gfx/gencon/pixel.inc"
ENDIF