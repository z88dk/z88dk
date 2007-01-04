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
;	$Id: plotpixl_smc.asm,v 1.1 2007-01-04 17:41:34 stefano Exp $
;


		XLIB	plotpixel

		LIB	pixel
		XREF	pixmode

.plotpixel	push	hl
		ld	hl,182 		; OR (HL)
		ld	(pixmode),hl
		pop	hl
		jp	pixel
