
; Unplot pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_respixel
    defc    NEEDunplot=1

w_respixel:
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
