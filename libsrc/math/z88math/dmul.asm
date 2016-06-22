;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dmul.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
		PUBLIC	dmul

		EXTERN	fsetup
		EXTERN	stkequ

		INCLUDE	"fpp.def"

.dmul
	call	fsetup
	fpp(FP_MUL)
	jp	stkequ

