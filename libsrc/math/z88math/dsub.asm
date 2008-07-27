;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dsub.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dsub

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.dsub
	call	fsetup
	fpp(FP_SUB)
	jp	stkequ

