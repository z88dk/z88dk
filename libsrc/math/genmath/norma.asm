;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: norma.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $

		XLIB	norma

		LIB	minusbc
		LIB	norm

;       reverse sign if necessary (cy set) and normalize
;       (sign reversal necessary because we're using
;       sign-magnitude representation rather than
;       twos-complement)
.norma
	call	c,minusbc
	jp	norm

