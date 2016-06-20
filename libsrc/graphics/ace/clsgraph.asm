;
;       Jupiter ACE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm,v 1.4 2016-06-20 21:47:41 dom Exp $
;

			SECTION   code_clib
			PUBLIC    cleargraphics
			EXTERN     loadudg6
			EXTERN	base_graphics

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
