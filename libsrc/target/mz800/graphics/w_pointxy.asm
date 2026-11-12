;
;	Sharp MZ-800 graphics: the pen of the pixel at (x,y)
;

    SECTION code_driver
    PUBLIC  w_pointxy
    defc    NEEDpoint=1

w_pointxy:
    INCLUDE "w_pixel.inc"
