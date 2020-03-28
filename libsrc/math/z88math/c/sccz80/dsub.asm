;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dsub.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dsub

		EXTERN	fsetup
		EXTERN	stkequ

IF FORz88
		INCLUDE	"target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

.dsub
	call	fsetup
IF FORz88
	fpp(FP_SUB)
ELSE
	ld	a,+(FP_SUB)
	call	FPP
ENDIF
	jp	stkequ

