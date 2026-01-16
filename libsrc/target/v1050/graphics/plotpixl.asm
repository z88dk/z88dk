;
;   Visual 1050 pseudo graphics routines
;	Version for the 2x3 graphics symbols (UDG redefined)
;
;       Written by Stefano Bodrato 2025
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl.asm $
;


    SECTION code_graphics
    PUBLIC  plotpixel

plotpixel:
    defc    NEEDplot=1
    INCLUDE "pixel6.inc"
