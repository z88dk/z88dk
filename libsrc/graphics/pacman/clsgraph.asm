;
;       Generic pseudo graphics routines for text-only platforms
;
;       PacMan HW port by Stefano Bodrato, 2017
;
;
;       Clears graph screen.
;
;
;	$Id:$
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	cleargraphics
			EXTERN	base_graphics


.cleargraphics

	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
;	ld	bc,+(maxx/2)*(maxy/2)
	ld	bc,$400
	ld	(hl),blankch
	ldir
	ld b,$4
	ld	(hl),20 ; palette
	ldir

	ret
