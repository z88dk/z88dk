;
;	Sharp MZ-2500 graphics: xor the pixel at (x,y) with the ink colour
;

    SECTION code_clib
    PUBLIC  w_xorpixel
    defc    NEEDxor=1

w_xorpixel:
    INCLUDE "w_pixel.inc"
