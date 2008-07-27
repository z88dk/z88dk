;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dmul.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dmul

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.dmul
	call	fsetup
	fpp(FP_MUL)
	jp	stkequ

