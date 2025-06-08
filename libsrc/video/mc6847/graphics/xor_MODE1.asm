
    SECTION code_clib

    PUBLIC  xor_MODE1
    INCLUDE "video/mc6847/mc6847.inc"

xor_MODE1:
    defc    NEEDxor=1
    INCLUDE "video/mc6847/graphics/pixel_MODE1.inc"
