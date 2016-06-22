;
;       Z88dk Z88 Maths Library
;
;
;       $Id: deq.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	deq

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS != FA?
.deq
	call	fsetup
	fpp(FP_EQ)
	jp	stkequcmp

