;
;   Visual 1050 pseudo graphics routines
;	Version for the 2x3 graphics symbols (UDG redefined)
;
;       Written by Stefano Bodrato 2025
;
;
;       Clear pixel at (x,y) coordinate.
;
;
;	$Id: respixl.asm $
;


    SECTION code_graphics
    PUBLIC  respixel

respixel:
    defc    NEEDunplot=1
    INCLUDE "pixel6.inc"
