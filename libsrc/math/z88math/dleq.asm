;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dleq.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dleq

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"fpp.def"

; TOS <= FA?
.dleq
	call	fsetup
	fpp(FP_LEQ)
	jp	stkequcmp

