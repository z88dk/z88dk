;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;
;       Reset pixel at (x,y) coordinate.
;
;
;   $Id: respixl.asm $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  respixel

    EXTERN  __gfx_coords
    EXTERN  __asm_pixeladdr
    INCLUDE "target/m100/def/romcalls.def"


respixel:

IF  _GFX_MAXX<>256
    ld      a, h
    cp      _GFX_MAXX
    ret     nc
ENDIF

IF  _GFX_MAXY<>256
    ld      a, l
    cp      _GFX_MAXY
    ret     nc                          ; y0    out of range
ENDIF

    push    bc
    ld      d, h
    ld      e, l
    ld      (__gfx_coords), hl
    
    call    __asm_pixeladdr

	CPL
    AND (HL)

    ROMCALL
    defw KY_LCDSET_TAIL

    POP  BC
    RET


 
