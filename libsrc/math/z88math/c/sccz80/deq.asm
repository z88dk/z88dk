;
;       Z88dk Z88 Maths Library
;
;
;       $Id: deq.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	deq

		EXTERN	fsetup
		EXTERN	stkequcmp

IF FORz88
		INCLUDE	"target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

; TOS != FA?
.deq
	call	fsetup
IF FORz88
	fpp(FP_EQ)
ELSE
	ld	a,+(FP_EQ)
	call	FPP
ENDIF
	jp	stkequcmp

