;
;	Sharp MZ-2500 graphics: read the pixel at (x,y): a = its colour, nz if not 0
;

    SECTION code_clib
    PUBLIC  w_pointxy
    defc    NEEDpoint=1

w_pointxy:
    INCLUDE "w_pixel.inc"
