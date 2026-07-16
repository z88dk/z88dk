;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;
;       Xor pixel at (x,y) coordinate.
;
;
;   $Id: xorpixl.asm $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  xorpixel

    EXTERN  __gfx_coords
    EXTERN  __asm_pixeladdr
    INCLUDE "target/m100/def/romcalls.def"


xorpixel:
    push    bc
    ld      d, h
    ld      e, l
    ld      (__gfx_coords), hl
    
    call    __asm_pixeladdr

    XOR (HL)

    ROMCALL
    defw LCDSET_TAIL

    POP  BC
    RET


 
