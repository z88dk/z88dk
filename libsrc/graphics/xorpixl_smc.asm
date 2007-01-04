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
;	$Id: xorpixl_smc.asm,v 1.1 2007-01-04 17:41:34 stefano Exp $
;


		XLIB	xorpixel

		LIB	pixel
		XREF	pixmode

.xorpixel	push	hl
		ld	hl,174		; XOR (HL)
		ld	(pixmode),hl
		pop	hl
		jp	pixel
