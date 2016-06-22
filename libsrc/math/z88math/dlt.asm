;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dlt.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dlt

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS < FA?
.dlt
	call	fsetup
	fpp(FP_LT)
	jp	stkequcmp

