;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dgt.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dgt

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS >= FA?
.dgt
	call	fsetup
	fpp(FP_GT)
	jp	stkequcmp

