;
;	Input8 -read in from a port
;
;	djm 7/3/2001

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
	


