;
;      Generic pseudo graphics routines for text-only platforms
;
;      Reset pixel at (x,y) coordinate.



        SECTION code_graphics
        PUBLIC  c_respixel
        defc    NEEDunplot=1


c_respixel:
        INCLUDE "w_c_pixel.inc"

