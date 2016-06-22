;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dge.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dge

		EXTERN	fsetup
		EXTERN	stkequcmp

		INCLUDE	"fpp.def"

; TOS >= FA?
.dge
	call	fsetup
	fpp(FP_GEQ)
	jp	stkequcmp

