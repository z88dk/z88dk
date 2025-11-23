;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: __gfx_vram_page_in.asm,v 1.7 2017-01-02 22:57:58 aralbrec Exp $
;

    MODULE  __tms9918___gfx_vram_page_in
    SECTION code_video_vdp
    PUBLIC  __gfx_vram_page_in
    PUBLIC  __gfx_vram_page_out

__gfx_vram_page_in:
__gfx_vram_page_out:
    ret
