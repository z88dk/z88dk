;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: fsub.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	fsub

		LIB	minusfa
		LIB	fadd

.fsub
	call minusfa
	jp	fadd

