;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.4 2011-08-12 20:39:44 pauloscustodio Exp $
;


			INCLUDE	"graphics/text/textgfx.inc"

			XLIB	cleargraphics
			XREF	base_graphics


.cleargraphics

	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,+(maxx/2)*(maxy/2)
	ld	(hl),blankch
	ldir

	ret
