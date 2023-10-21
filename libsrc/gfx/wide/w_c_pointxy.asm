;
;      Generic pseudo graphics routines for text-only platforms
;
;      Point pixel at (x,y) coordinate.



        SECTION code_graphics
        PUBLIC  c_pointxy
        defc    NEEDpoint=1


c_pointxy:
        INCLUDE "w_c_pixel.inc"

