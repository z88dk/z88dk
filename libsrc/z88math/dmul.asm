;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dmul.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dmul

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.dmul
	call	fsetup
	fpp(FP_MUL)
	jp	stkequ

