
    SECTION code_clib

    PUBLIC  xor_MODE2
    INCLUDE "video/mc6847/mc6847.inc"

xor_MODE2:
    ld      a, h
    cp      128
    ret     nc

    defc    NEEDxor=1
    INCLUDE "video/mc6847/graphics/pixel_MODE2.inc"
