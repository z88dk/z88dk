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
;	Stefano Bodrato - 27/02/2009
;
;
;	$Id: surface_draw.asm,v 1.5 2015-01-19 01:32:49 pauloscustodio Exp $
;


                PUBLIC    surface_draw
                
                ;LIB     swapgfxbk
                ;XREF    swapgfxbk1
                
		EXTERN	base_graphics

                EXTERN     Line
                EXTERN     surface_plotpixel


.surface_draw
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

		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		;call    swapgfxbk
		push	hl
		push    de
		call	surface_plotpixel
		pop     de
		pop	hl
                ld      ix,surface_plotpixel
                call    Line
                ;jp      swapgfxbk1
                ret
