;
;       Generic pseudo graphics routines for text-only platforms
;
;       Plot pixel at (x,y) coordinate.
;


        SECTION code_clib
        PUBLIC  plotpixel


plotpixel:
        defc    NEEDplot=1
        INCLUDE "pixel2.inc"
