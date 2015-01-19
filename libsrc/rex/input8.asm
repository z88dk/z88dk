;
;	Input8 -read in from a port
;
;	djm 7/3/2001
;
;	$Id: input8.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $

	PUBLIC	input8


.input8
	pop	hl
	pop	bc
	push	bc
	push	hl
	in	a,(c)
	ld	l,a
	ld	h,0
	ret
	


