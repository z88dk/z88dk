;
;       Z88dk Z88 Maths Library
;
;
;       $Id: ddiv.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	ddiv

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.ddiv
	call	fsetup
	fpp(FP_DIV)
	jp	stkequ

