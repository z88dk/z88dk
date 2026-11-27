
; Point pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_pointxy
    defc    NEEDpoint=1

w_pointxy:
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
