;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dleq.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dleq

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS <= FA?
.dleq
	call	fsetup
	fpp(FP_LEQ)
	jp	stkequcmp

