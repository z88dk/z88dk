;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: mgm_dsub.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:


		PUBLIC	dsub

		EXTERN	minusfa
		EXTERN	fadd

.dsub
	call minusfa
	pop	hl	;return address
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fadd

