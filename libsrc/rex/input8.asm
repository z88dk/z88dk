;
;	Input8 -read in from a port
;
;	djm 7/3/2001
;
;	$Id: input8.asm,v 1.3 2002-04-17 21:30:25 dom Exp $

	XLIB	input8


.input8
	pop	hl
	pop	bc
	push	bc
	push	hl
	in	a,(c)
	ld	l,a
	ld	h,0
	ret
	


