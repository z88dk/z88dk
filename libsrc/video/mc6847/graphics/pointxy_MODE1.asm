
    SECTION code_clib

    PUBLIC  pointxy_MODE1
    INCLUDE "video/mc6847/mc6847.inc"

pointxy_MODE1:

    defc    NEEDpoint=1
IFDEF MC6847_IOSPACE
    INCLUDE "video/mc6847/graphics/pixel_MODE1_IO.inc"
ELSE
    INCLUDE "video/mc6847/graphics/pixel_MODE1.inc"
ENDIF