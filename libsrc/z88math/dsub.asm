;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dsub.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dsub

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.dsub
	call	fsetup
	fpp(FP_SUB)
	jp	stkequ

