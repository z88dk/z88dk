;
;       Z88dk Z88 Maths Library
;
;
;       $Id: deq.asm,v 1.1 2002-12-12 10:11:55 dom Exp $

		XLIB	deq

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS != FA?
.deq
	call	fsetup
	fpp(FP_EQ)
	jp	stkequcmp

