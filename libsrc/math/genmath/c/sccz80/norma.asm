;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: norma.asm,v 1.3 2016-06-21 21:16:49 dom Exp $

        SECTION code_fp
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

