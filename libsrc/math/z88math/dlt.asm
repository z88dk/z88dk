;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dlt.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dlt

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS < FA?
.dlt
	call	fsetup
	fpp(FP_LT)
	jp	stkequcmp

