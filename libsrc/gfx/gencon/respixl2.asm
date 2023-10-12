;
;       Generic pseudo graphics routines for text-only platforms
;

        SECTION code_clib
        PUBLIC  respixel


respixel:
        defc    NEEDunplot=1
        INCLUDE "pixel2.inc"
