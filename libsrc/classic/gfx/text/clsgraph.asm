;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.8 2017-01-02 22:57:59 aralbrec Exp $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics
    PUBLIC  ___cleargraphics
    EXTERN  base_graphics


cleargraphics:
_cleargraphics:
___cleargraphics:

    ld      hl, (base_graphics)
    ld      d, h
    ld      e, l
    inc     de
    ld      bc, +(_GFX_MAXX/2)*(_GFX_MAXY/2)
    ld      (hl), _GFX_TEXT_BLANK_CHAR
    ldir

    ret
