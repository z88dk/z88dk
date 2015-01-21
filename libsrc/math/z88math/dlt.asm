;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dlt.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dlt

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS < FA?
.dlt
	call	fsetup
	fpp(FP_LT)
	jp	stkequcmp

