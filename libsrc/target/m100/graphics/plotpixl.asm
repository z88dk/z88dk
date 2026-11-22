;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;   $Id: plotpixl.asm $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  plotpixel

    EXTERN  __gfx_coords
    EXTERN  __asm_pixeladdr
    INCLUDE "target/m100/def/romcalls.def"


plotpixel:

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

    OR (HL)

    ROMCALL
    defw KY_LCDSET_TAIL

;  KY_LCDSET_TAIL in ROM being like:
;------------------------------------
;  LD (HL),A
;  LD B,D
;  LD E,$01
;  CALL SET_LCD
;  JP SET_CLOCK_HL_16
;------------------------------------

    POP  BC
    RET


 
