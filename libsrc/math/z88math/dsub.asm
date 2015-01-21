;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dsub.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dsub

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.dsub
	call	fsetup
	fpp(FP_SUB)
	jp	stkequ

