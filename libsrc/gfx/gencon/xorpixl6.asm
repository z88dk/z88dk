;
;       Generic pseudo graphics routines for text-only platforms
;
;       Xor pixel at (x,y) coordinate.


        SECTION code_clib
        PUBLIC  xorpixel


xorpixel:
        defc    NEEDxor=1
        INCLUDE "pixel6.inc"

