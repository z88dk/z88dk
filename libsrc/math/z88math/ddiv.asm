;
;       Z88dk Z88 Maths Library
;
;
;       $Id: ddiv.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	ddiv

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"fpp.def"

.ddiv
	call	fsetup
	fpp(FP_DIV)
	jp	stkequ

