;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.1 2002-01-30 10:11:13 stefano Exp $
;


			INCLUDE	"graphics/text/textgfx.inc"

			XLIB	cleargraphics
			XREF	base_graphics


.cleargraphics

	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,maxx*maxy
	ld	(hl),blankch
	ldir

	ret
