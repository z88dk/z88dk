;
;	Sharp MZ-2500 graphics: plot the pixel at (x,y) in the ink colour
;

    SECTION code_clib
    PUBLIC  w_plotpixel
    defc    NEEDplot=1

w_plotpixel:
    INCLUDE "w_pixel.inc"
