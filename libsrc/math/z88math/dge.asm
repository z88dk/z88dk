;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dge.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dge

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS >= FA?
.dge
	call	fsetup
	fpp(FP_GEQ)
	jp	stkequcmp

