;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dsub.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


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

