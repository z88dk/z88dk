;
;       Generic graphics routines
;	Self modifying code version
;
;       Stefano Bodrato - 4/1/2007
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl_smc.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;


		PUBLIC	plotpixel

		EXTERN	pixel
		EXTERN	pixmode

.plotpixel	push	hl
		ld	hl,182 		; OR (HL)
		ld	(pixmode),hl
		pop	hl
		jp	pixel
