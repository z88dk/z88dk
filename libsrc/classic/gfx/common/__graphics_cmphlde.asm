

    SECTION code_graphics
    PUBLIC  __graphics_cmphlde

    EXTERN  __gfx_vram_page_out
    INCLUDE "classic/gfx/grafix.inc"


__graphics_cmphlde:
	ld     a,e
	sub    l
	ret    nz
	ld     a,d
	sub    h
	ret
