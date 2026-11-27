
; Xor pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_xorpixel
    defc    NEEDxor=1

w_xorpixel:
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
