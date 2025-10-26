
    SECTION code_clib

    PUBLIC  xor_MODE1
    INCLUDE "classic/video/mc6847/mc6847.inc"

xor_MODE1:
    defc    NEEDxor=1
IFDEF MC6847_IOSPACE
    INCLUDE "classic/video/mc6847/graphics/pixel_MODE1_IO.inc"
ELSE
    INCLUDE "classic/video/mc6847/graphics/pixel_MODE1.inc"
ENDIF