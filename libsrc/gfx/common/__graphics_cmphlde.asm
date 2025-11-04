

    SECTION code_graphics
    PUBLIC  __graphics_cmphlde

    EXTERN  __gfx_page_vram_out
    INCLUDE "graphics/grafix.inc"


__graphics_cmphlde:
	ld     a,e
	sub    l
	ret    nz
	ld     a,d
	sub    h
	ret
