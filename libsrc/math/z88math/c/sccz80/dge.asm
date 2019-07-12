;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dge.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dge

		EXTERN	fsetup
		EXTERN	stkequcmp

IF FORz88
		INCLUDE	"target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

; TOS >= FA?
.dge
	call	fsetup
IF FORz88
	fpp(FP_GEQ)
ELSE
	ld	a,+(FP_GEQ)
	call	FPP
ENDIF
	jp	stkequcmp

