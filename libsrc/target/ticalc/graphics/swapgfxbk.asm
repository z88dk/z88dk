;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;	TI calcs: Copy GRAPH MEM to LCD when finished.
;	By Stefano Bodrato - Dec. 2000
;
;
;	$Id: __gfx_page_vram_in.asm,v 1.9 2017-01-02 22:57:59 aralbrec Exp $
;

    SECTION code_graphics
    PUBLIC  __gfx_page_vram_in
    PUBLIC  ___gfx_page_vram_in
    PUBLIC  __gfx_page_vram_out
    PUBLIC  ___gfx_page_vram_out

    EXTERN  cpygraph


__gfx_page_vram_out:
___gfx_page_vram_out:
    push    hl
    push    de
    push    bc

    call    cpygraph                    ; Copy GRAPH_MEM to LCD, then return

    pop     bc
    pop     de
    pop     hl

__gfx_page_vram_in:
___gfx_page_vram_in:
    ret
