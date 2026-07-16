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
    push    bc
    ld      d, h
    ld      e, l
    ld      (__gfx_coords), hl
    
    call    __asm_pixeladdr

    OR (HL)

    ROMCALL
    defw LCDSET_TAIL

    POP  BC
    RET


 
