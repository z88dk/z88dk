;
;       Z88dk Z88 Maths Library
;
;
;       $Id: deq.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	deq

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS != FA?
.deq
	call	fsetup
	fpp(FP_EQ)
	jp	stkequcmp

