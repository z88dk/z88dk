;
;	Samsung SPC-1500 graphics: plot the pixel at (x,y) in the ink pen
;

    SECTION code_clib
    PUBLIC  w_plotpixel
    defc    NEEDplot=1

w_plotpixel:
    INCLUDE "w_pixel.inc"
