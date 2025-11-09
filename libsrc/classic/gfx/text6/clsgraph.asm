;
;       Generic pseudo graphics routines for text-only platforms
;       Version for the 2x3 or 1x3 graphics symbols
;
;       Written by Stefano Bodrato 19/12/2006
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm $
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
IF  GFXTEXT3
    ld      bc, _GFX_MAXX*_GFX_MAXY/3-1
ELSE
    ld      bc, _GFX_MAXX*_GFX_MAXY/6-1
ENDIF
clean:
    ld      (hl), _GFX_TEXT_BLANK_CHAR
    inc     hl
    dec     bc
    ld      a, b
    or      c
    jr      nz, clean

    ret
