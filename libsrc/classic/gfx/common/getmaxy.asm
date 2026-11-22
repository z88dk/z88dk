;
;      Z88 Graphics Functions
;
;      Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;


    INCLUDE "classic/gfx/grafix.inc"


    SECTION code_graphics
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    PUBLIC  ___getmaxy

getmaxy:
_getmaxy:
___getmaxy:
    ld      hl, _GFX_MAXY-1
    ret
