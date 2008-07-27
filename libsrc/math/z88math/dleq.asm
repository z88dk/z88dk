;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dleq.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dleq

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS <= FA?
.dleq
	call	fsetup
	fpp(FP_LEQ)
	jp	stkequcmp

