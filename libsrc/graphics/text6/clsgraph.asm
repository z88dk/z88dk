;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 19/12/2006
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.2 2014-05-26 06:15:06 stefano Exp $
;


			INCLUDE	"graphics/grafix.inc"

			XLIB	cleargraphics
			XREF	base_graphics


.cleargraphics

	ld	hl,(base_graphics)
	ld	bc,maxx*maxy/6-1
.clean
	ld	(hl),blankch
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clean

	ret
