;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dadd.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dadd

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.dadd
	call	fsetup
	fpp(FP_ADD)
	jp	stkequ

