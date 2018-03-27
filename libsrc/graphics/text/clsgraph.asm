;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm,v 1.8 2017-01-02 22:57:59 aralbrec Exp $
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	cleargraphics
         PUBLIC   _cleargraphics
			EXTERN	base_graphics


.cleargraphics
._cleargraphics

	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,+(maxx/2)*(maxy/2)
	ld	(hl),blankch
	ldir

	ret
