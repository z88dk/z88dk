;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dadd.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dadd

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.dadd
	call	fsetup
	fpp(FP_ADD)
	jp	stkequ

