;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dmul.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dmul

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"fpp.def"

.dmul
	call	fsetup
	fpp(FP_MUL)
	jp	stkequ

