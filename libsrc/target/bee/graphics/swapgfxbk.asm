;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: __gfx_vram_page_in.asm,v 1.2 2017-01-02 21:51:24 aralbrec Exp $
;


    SECTION code_clib
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out


__gfx_vram_page_in:
___gfx_vram_page_in:
    di
    ret

__gfx_vram_page_out:
___gfx_vram_page_out:
    di
;	ld a,128		; premium graphics on
;	out ($1c),a
		;ei
    ret

