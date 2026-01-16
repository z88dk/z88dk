;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MC-1000, but we hang the interrupts,
;		just in case they become critical.
;
;
;	$Id: __gfx_vram_page_in.asm,v 1.5 2017-01-02 22:57:58 aralbrec Exp $
;


    SECTION code_clib
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in
    EXTERN  pixeladdress

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out

__gfx_vram_page_in:
___gfx_vram_page_in:
__gfx_vram_page_out:
___gfx_vram_page_out:
    ret
