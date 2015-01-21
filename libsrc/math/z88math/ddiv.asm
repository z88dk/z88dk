;
;       Z88dk Z88 Maths Library
;
;
;       $Id: ddiv.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	ddiv

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.ddiv
	call	fsetup
	fpp(FP_DIV)
	jp	stkequ

