;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dlt.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dlt

		EXTERN	fsetup
		EXTERN	stkequcmp

IF FORz88
		INCLUDE	"target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

; TOS < FA?
.dlt
	call	fsetup
IF FORz88
	fpp(FP_LT)
ELSE
	ld	a,+(FP_LT)
	call	FPP
ENDIF
	jp	stkequcmp

