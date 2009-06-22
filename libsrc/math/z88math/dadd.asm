;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dadd.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dadd

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"fpp.def"

.dadd
	call	fsetup
	fpp(FP_ADD)
	jp	stkequ

