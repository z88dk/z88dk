;
;       Generic pseudo graphics routines for text-only platforms
;



        SECTION code_clib
        PUBLIC  xorpixel

xorpixel:
        defc    NEEDxor=1
        INCLUDE "pixel.inc"
