;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dadd.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	dadd

		LIB	fadd

.dadd
	pop	hl
	pop	de
	pop	ix
	pop	bc
	push	hl
	jp	fadd
