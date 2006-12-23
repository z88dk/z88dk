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
;	$Id: clsgraph.asm,v 1.1 2006-12-23 21:33:10 stefano Exp $
;


			INCLUDE	"graphics/text6/textgfx.inc"

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
