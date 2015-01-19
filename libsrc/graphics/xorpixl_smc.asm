;
;       Generic graphics routines
;	Self modifying code version
;
;       Stefano Bodrato - 4/1/2007
;
;
;       Invert pixel at (x,y) coordinate.
;
;
;	$Id: xorpixl_smc.asm,v 1.2 2015-01-19 01:32:47 pauloscustodio Exp $
;


		PUBLIC	xorpixel

		EXTERN	pixel
		EXTERN	pixmode

.xorpixel	push	hl
		ld	hl,174		; XOR (HL)
		ld	(pixmode),hl
		pop	hl
		jp	pixel
