;
;	Sharp MZ-2500 graphics: reset the pixel at (x,y) to the paper colour
;

    SECTION code_clib
    PUBLIC  w_respixel
    defc    NEEDunplot=1

w_respixel:
    INCLUDE "w_pixel.inc"
