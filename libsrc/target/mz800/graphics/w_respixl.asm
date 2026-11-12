;
;	Sharp MZ-800 graphics: clear the pixel at (x,y) to the paper pen
;

    SECTION code_driver
    PUBLIC  w_respixel
    defc    NEEDunplot=1

w_respixel:
    INCLUDE "w_pixel.inc"
