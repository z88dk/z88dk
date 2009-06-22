;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dsub.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dsub

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"fpp.def"

.dsub
	call	fsetup
	fpp(FP_SUB)
	jp	stkequ

