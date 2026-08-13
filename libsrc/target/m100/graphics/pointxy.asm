;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;
;       Test pixel at (x,y) coordinate.
;
;
;   $Id: pointxy.asm $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  pointxy

    EXTERN  __gfx_coords
    EXTERN  __asm_pixeladdr
    INCLUDE "target/m100/def/romcalls.def"


pointxy:

    push    bc
    push    de
    push    hl

    ld      d, h
    ld      e, l

    call    __asm_pixeladdr

    AND (HL)

    pop     hl
    pop     de
    pop     bc

    RET


 
