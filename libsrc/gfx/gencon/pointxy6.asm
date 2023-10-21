;
;       Generic pseudo graphics routines for text-only platforms
;
;       Point pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC  pointxy


pointxy:
        defc    NEEDpoint=1
        INCLUDE "pixel6.inc"

