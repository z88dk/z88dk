;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dlt.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dlt

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"fpp.def"

; TOS < FA?
.dlt
	call	fsetup
	fpp(FP_LT)
	jp	stkequcmp

