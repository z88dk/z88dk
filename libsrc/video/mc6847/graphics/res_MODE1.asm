
    SECTION code_clib

    PUBLIC  res_MODE1
    INCLUDE "video/mc6847/mc6847.inc"

res_MODE1:
    defc    NEEDunplot=1
    INCLUDE "video/mc6847/graphics/pixel_MODE1.inc"
