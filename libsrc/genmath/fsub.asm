;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: fsub.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	fsub

		LIB	minusfa
		LIB	fadd

.fsub
	call minusfa
	jp	fadd

