;
;	Input8 -read in from a port
;
;	djm 7/3/2001
;
;	$Id: input8.asm,v 1.5 2017-01-03 00:11:31 aralbrec Exp $

	PUBLIC	input8
   PUBLIC   _input8


.input8
._input8
	pop	hl
	pop	bc
	push	bc
	push	hl
	in	a,(c)
	ld	l,a
	ld	h,0
	ret
	


