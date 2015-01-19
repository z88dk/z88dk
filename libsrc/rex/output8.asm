;
;	Input8 -read in from a port
;
;	djm 7/3/2001
;
;	$Id: output8.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $

	PUBLIC	output8


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
	


