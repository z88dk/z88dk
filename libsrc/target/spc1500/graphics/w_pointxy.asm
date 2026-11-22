;
;	Samsung SPC-1500 graphics: the pen of the pixel at (x,y)
;

    SECTION code_clib
    PUBLIC  w_pointxy
    defc    NEEDpoint=1

w_pointxy:
    INCLUDE "w_pixel.inc"
