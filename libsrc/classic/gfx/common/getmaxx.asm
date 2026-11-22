;
;      Z88 Graphics Functions
;
;      Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;


    INCLUDE "classic/gfx/grafix.inc"


    SECTION code_graphics
    PUBLIC  getmaxx
    PUBLIC  _getmaxx

getmaxx:
_getmaxx:
___getmaxx:
    ld      hl, _GFX_MAXX-1
    ret
