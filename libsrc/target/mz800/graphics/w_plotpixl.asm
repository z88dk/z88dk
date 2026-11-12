;
;	Sharp MZ-800 graphics: plot the pixel at (x,y) in the ink pen
;

    SECTION code_driver
    PUBLIC  w_plotpixel
    defc    NEEDplot=1

w_plotpixel:
    INCLUDE "w_pixel.inc"
