;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dlt.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dlt

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS < FA?
.dlt
	call	fsetup
	fpp(FP_LT)
	jp	stkequcmp

