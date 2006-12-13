;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.3 2006-12-13 18:08:23 stefano Exp $
;


			INCLUDE	"graphics/text/textgfx.inc"

			XLIB	cleargraphics
			XREF	base_graphics


.cleargraphics

	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,(maxx/2)*(maxy/2)
	ld	(hl),blankch
	ldir

	ret
