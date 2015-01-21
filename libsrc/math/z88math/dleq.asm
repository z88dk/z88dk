;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dleq.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dleq

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS <= FA?
.dleq
	call	fsetup
	fpp(FP_LEQ)
	jp	stkequcmp

