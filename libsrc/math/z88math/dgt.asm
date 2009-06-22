;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dgt.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dgt

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"fpp.def"

; TOS >= FA?
.dgt
	call	fsetup
	fpp(FP_GT)
	jp	stkequcmp

