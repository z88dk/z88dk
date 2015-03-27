;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: norma.asm,v 1.1 2015-03-27 06:03:29 aralbrec Exp $

		PUBLIC	norma

		EXTERN	minusbc
		EXTERN	norm

;       reverse sign if necessary (cy set) and normalize
;       (sign reversal necessary because we're using
;       sign-magnitude representation rather than
;       twos-complement)
.norma
	call	c,minusbc
	jp	norm

