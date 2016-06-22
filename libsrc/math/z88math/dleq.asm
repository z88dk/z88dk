;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dleq.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dleq

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS <= FA?
.dleq
	call	fsetup
	fpp(FP_LEQ)
	jp	stkequcmp

