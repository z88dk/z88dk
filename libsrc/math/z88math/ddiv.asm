;
;       Z88dk Z88 Maths Library
;
;
;       $Id: ddiv.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	ddiv

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.ddiv
	call	fsetup
	fpp(FP_DIV)
	jp	stkequ

