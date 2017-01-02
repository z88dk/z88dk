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
;	$Id: clsgraph.asm,v 1.5 2017-01-02 22:57:59 aralbrec Exp $
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	cleargraphics
         PUBLIC   _cleargraphics
			EXTERN	base_graphics


.cleargraphics
._cleargraphics

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
