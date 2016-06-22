;
;       Z88dk Z88 Maths Library
;
;
;       $Id: ddiv.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	ddiv

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.ddiv
	call	fsetup
	fpp(FP_DIV)
	jp	stkequ

