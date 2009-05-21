;
;	MSX extension for "GFX - a small graphics library" by Jannone
;

;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       MSX buffered display extension
;	compatibility layer for "GFX",
;	 a small graphics library by Rafael de Oliveira Jannone
;
;	Stefano Bodrato - 18/03/2009
;
;
;	$Id: surface_circle.asm,v 1.2 2009-05-21 06:58:11 stefano Exp $
;


                XLIB    surface_circle
                
                ;LIB     swapgfxbk
                ;XREF    swapgfxbk1
                
		XREF	base_graphics

                LIB     draw_circle
                LIB     surface_plotpixel


.surface_circle
		ld	ix,0
		add	ix,sp

		ld	l,(ix+10)	; surface struct
		ld	h,(ix+11)
		ld	de,6		; shift to screen buffer ptr
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	(base_graphics),de

		ld	e,(ix+2)	;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x

		;call    swapgfxbk
                ld      ix,surface_plotpixel
                call    draw_circle
                ;jp      swapgfxbk1
                ret
