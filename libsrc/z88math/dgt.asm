;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dgt.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dgt

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS >= FA?
.dgt
	call	fsetup
	fpp(FP_GT)
	jp	stkequcmp

