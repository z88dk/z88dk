;
;	Samsung SPC-1500 graphics: clear the pixel at (x,y) to the paper pen
;

    SECTION code_clib
    PUBLIC  w_respixel
    defc    NEEDunplot=1

w_respixel:
    INCLUDE "w_pixel.inc"
