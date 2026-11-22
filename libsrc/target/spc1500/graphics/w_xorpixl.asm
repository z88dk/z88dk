;
;	Samsung SPC-1500 graphics: turn the pixel at (x,y) from the ink to the
;	paper pen or back
;

    SECTION code_clib
    PUBLIC  w_xorpixel
    defc    NEEDxor=1

w_xorpixel:
    INCLUDE "w_pixel.inc"
