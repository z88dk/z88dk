;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dadd.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $

		XLIB	dadd

		LIB	fsetup
		LIB	stkequ

		INCLUDE	"#fpp.def"

.dadd
	call	fsetup
	fpp(FP_ADD)
	jp	stkequ

