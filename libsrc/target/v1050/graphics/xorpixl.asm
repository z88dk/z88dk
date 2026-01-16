;
;   Visual 1050 pseudo graphics routines
;	Version for the 2x3 graphics symbols (UDG redefined)
;
;       Written by Stefano Bodrato 2025
;
;
;       Xor pixel at (x,y) coordinate.
;
;
;	$Id: xorpixl.asm $
;


    SECTION code_graphics
    PUBLIC  xorpixel

xorpixel:
    defc    NEEDxor=1
    INCLUDE "pixel6.inc"
