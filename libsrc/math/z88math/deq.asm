;
;       Z88dk Z88 Maths Library
;
;
;       $Id: deq.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	deq

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"fpp.def"

; TOS != FA?
.deq
	call	fsetup
	fpp(FP_EQ)
	jp	stkequcmp

