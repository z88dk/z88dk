
	XLIB	xorpixel

	XREF	COORDS

;
;	$Id: xorpixl.asm,v 1.1 2007-12-18 09:00:45 stefano Exp $
;

; ******************************************************************
;
; XORs pixel at (x,y) coordinate.
;
;
	LIB	pointxy
	LIB	plotpixel
	LIB	respixel

.xorpixel
		push	hl
		call	pointxy
		pop	hl
		jp	nz,plotpixel
		jp	respixel
