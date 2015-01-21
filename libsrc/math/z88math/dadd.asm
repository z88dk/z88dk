;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dadd.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $

		PUBLIC	dadd

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.dadd
	call	fsetup
	fpp(FP_ADD)
	jp	stkequ

