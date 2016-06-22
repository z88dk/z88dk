;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dgt.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dgt

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS >= FA?
.dgt
	call	fsetup
	fpp(FP_GT)
	jp	stkequcmp

