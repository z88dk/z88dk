;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dge.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dge

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS >= FA?
.dge
	call	fsetup
	fpp(FP_GEQ)
	jp	stkequcmp

