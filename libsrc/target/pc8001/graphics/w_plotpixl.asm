
; Plot pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_plotpixel
    defc    NEEDplot=1

w_plotpixel:
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
