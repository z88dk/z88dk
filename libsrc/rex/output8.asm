;
;	Input8 -read in from a port
;
;	djm 7/3/2001
;
;	$Id: output8.asm,v 1.2 2001-09-03 16:13:20 dom Exp $

	XLIB	output8


.output8
	pop	hl
	pop	de	;value
	pop	bc	;port
	push	bc
	push	de
	push	hl
	ld	a,e
	out	(c),a
	ld	l,a
	ld	h,0
	ret
	


