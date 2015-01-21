;
;       Z88dk Z88 Maths Library
;
;
;       $Id: deq.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	deq

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS != FA?
.deq
	call	fsetup
	fpp(FP_EQ)
	jp	stkequcmp

