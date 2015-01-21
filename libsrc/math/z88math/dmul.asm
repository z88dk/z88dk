;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dmul.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dmul

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.dmul
	call	fsetup
	fpp(FP_MUL)
	jp	stkequ

