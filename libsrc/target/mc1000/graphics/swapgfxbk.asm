;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MC-1000, but we hang the interrupts,
;		just in case they become critical.
;
;
;	$Id: __gfx_page_vram_in.asm,v 1.5 2017-01-02 22:57:58 aralbrec Exp $
;


    SECTION code_clib
    PUBLIC  __gfx_page_vram_in
    PUBLIC  ___gfx_page_vram_in
    EXTERN  pixeladdress

    PUBLIC  __gfx_page_vram_out
    PUBLIC  ___gfx_page_vram_out

__gfx_page_vram_in:
___gfx_page_vram_in:
__gfx_page_vram_out:
___gfx_page_vram_out:
    ret
