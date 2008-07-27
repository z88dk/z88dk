;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dgt.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dgt

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS >= FA?
.dgt
	call	fsetup
	fpp(FP_GT)
	jp	stkequcmp

