;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.6 2016-06-16 19:53:50 dom Exp $
;


			INCLUDE	"graphics/text/textgfx.inc"

		        SECTION code_clib
			PUBLIC	cleargraphics
			EXTERN	base_graphics


.cleargraphics

	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,+(maxx/2)*(maxy/2)
	ld	(hl),blankch
	ldir

	ret
