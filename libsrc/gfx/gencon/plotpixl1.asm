;
;       Generic pseudo graphics routines for text-only platforms
;
;       Plot pixel1 at (x,y) coordinate.
;


        SECTION code_clib
        PUBLIC  plotpixel


plotpixel:
        defc    NEEDplot=1
        INCLUDE "pixel1.inc"
