;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dsub.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dsub

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.dsub
	call	fsetup
	fpp(FP_SUB)
	jp	stkequ

