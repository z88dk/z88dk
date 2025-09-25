;
;   Visual 1050 pseudo graphics routines
;	Version for the 2x3 graphics symbols (UDG redefined)
;
;       Written by Stefano Bodrato 2025
;
;
;       Pick pixel at (x,y) coordinate.
;
;
;	$Id: pointxy.asm $
;


    SECTION code_graphics
    PUBLIC  pointxy

pointxy:
    defc    NEEDpoint=1
    INCLUDE "pixel6.inc"
