;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dadd.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	dadd

		LIB	fadd

.dadd
	pop	hl
	pop	de
	pop	ix
	pop	bc
	push	hl
	jp	fadd
