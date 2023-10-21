;
;     Generic pseudo graphics routines for text-only platforms
;
;     Xor pixel at (x,y) coordinate.


        SECTION code_graphics
        PUBLIC  c_xorpixel
        defc    NEEDxor=1



c_xorpixel:
        INCLUDE "c_pixel.inc"
