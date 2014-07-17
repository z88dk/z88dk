;
;       Jupiter ACE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm,v 1.2 2014-07-17 09:37:53 stefano Exp $
;


			XLIB    cleargraphics
			LIB     loadudg6
			XREF	base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
	
	ld   c,0	; first UDG chr$ to load
	ld	 b,64	; number of characters to load
	ld   hl,$2c00	; UDG area
	call loadudg6

	ld	hl,(base_graphics)
	ld	bc,maxx*maxy/6
.clean
	ld	(hl),blankch
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clean

	ret
