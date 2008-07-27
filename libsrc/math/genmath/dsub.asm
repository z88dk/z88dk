;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dsub.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	dsub

		LIB	minusfa
		LIB	fadd

.dsub
	call minusfa
	pop	hl	;return address
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fadd

